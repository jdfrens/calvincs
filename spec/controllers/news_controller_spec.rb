require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NewsController, "without views" do
  user_fixtures

  context "index action" do
    it "should show listing and news items" do
      news_items = mock("news items")
      updated_at = mock("updated at time")

      NewsItem.should_receive(:find_current).and_return(news_items)
      news_items.should_receive(:maximum).with(:updated_at).and_return(updated_at)

      get :index

      assert_response :success
      assigns[:news_items].should == news_items
      assigns[:title].should == "Current News"
      assigns[:last_updated].should == updated_at
    end

    # TODO: it "should redirect to list if no current news items?"

    it "should list years with actual news" do
      news_years = mock("news years")

      NewsItem.should_receive(:find_news_years).and_return(news_years)

      get :index, { :year => "all" }

      assert_response :success
      response.should render_template("archive")
      assigns[:title].should == "News Archive"
      assigns[:years].should == news_years
    end

    it "should list by year" do
      news_items = mock("news items")
      updated_at = mock("updated at time")

      NewsItem.should_receive(:find_by_year).with(1666, :today).and_return(news_items)
      news_items.should_receive(:maximum).with(:updated_at).and_return(updated_at)

      get :index, { :year => "1666" }

      assert_response :success
      assigns[:news_items].should == news_items
      assigns[:title].should == "News of 1666"
      assigns[:last_updated].should == updated_at
    end

    context "when logged in" do
      it "should all news items in the year" do
        news_items = mock("news items")
        updated_at = mock("updated at time")

        NewsItem.should_receive(:find_by_year).with(1492, :all).and_return(news_items)
        news_items.should_receive(:maximum).with(:updated_at).and_return(updated_at)

        get :index, { :year => "1492" }, user_session(:edit)

        assert_response :success
        assigns[:news_items].should == news_items
        assigns[:title].should == "News of 1492"
      end
    end
  end

  context "editing a news item" do
    it "should find the news item to be edited" do
      news_item = mock_model(NewsItem)
      NewsItem.should_receive(:find).with("456").and_return(news_item)

      get :edit, { :id => "456" }, user_session(:edit)

      response.should render_template("news/new")
      assigns[:news_item].should == news_item
    end

    it "should redirect to login when not logged in" do
      get :edit

      response.should redirect_to("/users/login")
    end
  end

  context "show action" do
    it "should show basic news item" do
      updated_at = mock("updated at")
      item = mock_model(NewsItem, :headline => "The Headline", :updated_at => updated_at)

      NewsItem.should_receive(:find).with(item.id.to_s).and_return(item)

      get :show, { :id => item.id }

      assert_response :success
      assigns[:news_item].should == item
      assigns[:title].should == "The Headline"
      assigns[:last_updated].should == updated_at
    end

    it "should show more detail when logged in" do
      updated_at = mock("updated at")
      item = mock_model(NewsItem, :headline => "The Headline", :updated_at => updated_at)

      NewsItem.should_receive(:find).with(item.id.to_s).and_return(item)

      get :show, { :id => item.id }, user_session(:edit)

      assert_response :success
      assigns[:news_item].should == item
      assigns[:title].should == "The Headline"
      assigns[:last_updated].should == updated_at
    end
  end

  context "create action" do
    it "should redirect when NOT logged in" do
      post :create

      response.should redirect_to(:controller => "users", :action => "login")
    end

    it "should create a new news item" do
      news_item = mock_model(NewsItem)

      NewsItem.should_receive(:new).
              with("user_id" => users(:jeremy).id, "params" => "values").
              and_return(news_item)
      news_item.should_receive(:save).and_return(true)

      post :create, { :news_item => { :params => "values" } }, user_session(:edit)

      response.should redirect_to(:controller => 'news', :action => 'index')
    end

    it "should redirect when not saved" do
      news_item = mock_model(NewsItem)

      NewsItem.should_receive(:new).
              with("user_id" => users(:jeremy).id, "params" => "values").
              and_return(news_item)
      news_item.should_receive(:save).and_return(false)

      post :create, { :news_item => { :params => "values" } }, user_session(:edit)

      response.should render_template("news/new")
    end
  end

end

describe NewsController do
  integrate_views

  fixtures :news_items
  user_fixtures

  describe "response to GET new" do
    it "should redirect when not logged in" do
      get :new

      response.should redirect_to(:controller => 'users', :action => 'login')
    end


    context "when logged in" do
      it "should create new news item" do
        get :new, {}, user_session(:edit)

        assert_response :success
        assert_select "h1", "Create News Item"
        assert_select "form[action=/news/save]" do
          assert_select "tr:nth-child(1)" do
            assert_select "td", /headline/i
            assert_select "td input[type=text]"
          end
          assert_select "tr:nth-child(2)" do
            assert_select "td", /teaser/i
            assert_select "td input[type=text]"
          end
          assert_select "tr:nth-child(3)" do
            assert_select "td", /content/i
            assert_select "td textarea"
          end
          assert_date_entry(4, /goes live/i, Time.now, "goes_live_at")
          assert_date_entry(5, /expires/i, 1.month.from_now, "expires_at")
          assert_select "input[type=submit]"
        end
      end
    end
  end

  context "setting headline of news item" do
    context "when logged in" do
      it "should set the headline" do
        xhr :post, :set_news_item_headline,
                { :id => news_items(:todays_news).id, :value => 'New Headline' },
                user_session(:edit)
        assert_response :success
        assert_equal "New Headline", response.body

        assert_equal 'New Headline', NewsItem.find(news_items(:todays_news).id).headline
      end
    end

    context "when NOT logged in" do
      it "should redirect" do
        xhr :get, :set_news_item_headline, :id => news_items(:todays_news).id, :value => 'New HeadLine'

        response.should redirect_to(:controller => "users", :action => "login")
        assert_equal "News of Today", news_items(:todays_news).headline,
                'headline remains unchanged'
      end
    end
  end

  context "setting teaser of news item" do
    context "when logged in" do
      it "should set the teaser" do
        xhr :get, :set_news_item_teaser,
                { :id => news_items(:todays_news).id, :value => 'Teaser of Newness' },
                user_session(:edit)

        assert_response :success
        assert_equal "Teaser of Newness", response.body

        assert_equal 'Teaser of Newness', NewsItem.find(news_items(:todays_news).id).teaser
      end
    end

    context "when NOT logged in" do
      it "should redirect" do
        xhr :get, :set_news_item_teaser, :id => news_items(:todays_news).id, :value => 'Teaser Teaser'

        response.should redirect_to(:controller => "users", :action => "login")
        assert_equal "Some *teaser*.", news_items(:todays_news).teaser,
                'teaser remains unchanged'
      end
    end
  end

  context "updating content of news item" do
    context "when logged in" do
      it "should update content" do
        item = news_items(:todays_news)
        xhr :get, :update_news_item_content,
                { :id => item.id, :news_item => { :content => 'News that is fit to print.' } },
                user_session(:edit)

        assert_response :success
        assert_select_rjs :replace_html, "news-item-content" do
          response.body.should match(/News that is fit to print./)
        end

        item.reload
        assert_equal 'News that is fit to print.', item.content
      end
    end

    context "when NOT logged in" do
      it "should redirect" do
        item = news_items(:todays_news)
        original_content = item.content
        xhr :get, :update_news_item_content,
                { :id => item.id, :news_item => { :content => 'foobar!' } }

        response.should redirect_to(:controller => "users", :action => "login")
        item.reload
        assert_equal original_content, item.content
      end
    end
  end

  context "set goes live date of news item" do
    context "when logged in" do
      it "should set goes live date" do
        item = news_items(:todays_news)
        xhr :get, :set_news_item_goes_live_at_formatted,
                { :id => item.id, :value => '01/05/2007' }, user_session(:edit)

        assert_response :success
        assert_equal '01/05/2007', response.body
        item.reload
        assert_equal '01/05/2007', item.goes_live_at_formatted
      end
    end

    context "when NOT logged in" do
      it "should redirect" do
        item = news_items(:todays_news)
        original_date = item.goes_live_at
        xhr :get, :set_news_item_goes_live_at_formatted,
                { :id => news_items(:todays_news).id, :value => '01/05/2007' }

        response.should redirect_to(:controller => "users", :action => "login")
        item.reload
        assert_equal original_date, item.goes_live_at, 'goes-live remains unchanged'
      end
    end
  end

  context "set expired at date of news item" do
    context "when logged in" do
      it "should set expired at date" do
        item = news_items(:todays_news)
        xhr :get, :set_news_item_expires_at_formatted,
                { :id => item.id, :value => '01/05/2007' }, user_session(:edit)
        assert_response :success
        assert_equal '01/05/2007', response.body
        item.reload
        assert_equal '01/05/2007', item.expires_at_formatted
      end
    end

    context "when NOT logged in" do
      it "should redirect" do
        item = news_items(:todays_news)
        original_date = item.expires_at
        xhr :get, :set_news_item_expires_at_formatted,
                { :id => item.id, :value => '01/05/2007' }

        response.should redirect_to(:controller => "users", :action => "login")
        item.reload
        assert_equal original_date, item.expires_at, 'expires-at remains unchanged'
      end
    end
  end

  context "destroy action" do
    context "when NOT logged in" do
      it "should redirect" do
        post :destroy, { :id => news_items(:todays_news).id }

        response.should redirect_to(:controller => "users", :action => "login")
        assert_equal 4, NewsItem.count, "should still have four news items"
      end
    end

    context "when logged in" do
      it "should destroy" do
        assert_not_nil NewsItem.find_by_headline("News of Today"), "sanity check"
        assert_equal 4, NewsItem.count

        post :destroy, { :id => news_items(:todays_news).id, :listing => 'foobar' },
                user_session(:edit)

        assert_redirected_to :controller => 'news', :action => 'list', :id => 'foobar'
        assert_equal 3, NewsItem.count, "lost just one news item"
        assert_nil NewsItem.find_by_headline("News of Today")
      end
    end
  end

  #
  # Helpers
  #
  private

  def current_year
    news_items(:todays_news).goes_live_at.year
  end

  def assert_date_entry(nth, label, date, field)
    assert_select "tr:nth-child(#{nth})" do
      assert_select "td", label
      assert_select "td select#news_item_#{field}_1i" do
        assert_select "option[value=#{date.year}][selected=selected]"
      end
      assert_select "td select#news_item_#{field}_2i" do
        assert_select "option[value=#{date.month}][selected=selected]"
      end
      assert_select "td select#news_item_#{field}_3i" do
        assert_select "option[value=#{date.day}][selected=selected]"
      end
    end
  end

  def assert_news_item_entry(n, news_item, listing)
    time_class = news_item.is_current? ? "current-news" : "past-news"
    assert_select "tr[class=#{time_class}]:nth-child(#{n*2-1})" do
      assert_select "td a[href=/news/view/#{news_item.id}]", news_item.headline
    end
    assert_select "tr[class=#{time_class}]:nth-child(#{n*2})" do
      assert_select "td.goes-live-date", "posted on #{news_item.goes_live_at.to_s(:news_posted)}"
    end
  end

  def assert_full_news_item(news_item)
    assert_select "div#news-item-#{news_item.id}[class=news-item]" do
      assert_select "h2", news_item.headline
      assert_select "p.goes-live-date", "Posted on #{news_item.goes_live_at.to_s(:news_posted)}"
      assert_select "div.content", news_item.content
      assert_select "p.more a[href=#top]", "back to top..."
    end
  end

end
