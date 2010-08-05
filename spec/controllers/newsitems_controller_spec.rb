require 'spec_helper'

describe NewsitemsController, "without views" do
  user_fixtures

  context "index action" do
    it "should show listing and news items" do
      newsitems = mock("news items")
      updated_at = mock("updated at time")

      Newsitem.should_receive(:find_current).and_return(newsitems)
      newsitems.should_receive(:maximum).with(:updated_at).and_return(updated_at)

      get :index

      assert_response :success
      assigns[:newsitems].should == newsitems
      assigns[:title].should == "Current News"
      assigns[:last_updated].should == updated_at
    end

    it "should list years with actual news" do
      news_years = mock("news years")

      Newsitem.should_receive(:find_news_years).and_return(news_years)

      get :index, { :year => "all" }

      assert_response :success
      response.should render_template("archive")
      assigns[:title].should == "News Archive"
      assigns[:years].should == news_years
    end

    it "should list by year" do
      newsitems = mock("news items")
      updated_at = mock("updated at time")

      Newsitem.should_receive(:find_by_year).with(1666, :today).and_return(newsitems)
      newsitems.should_receive(:maximum).with(:updated_at).and_return(updated_at)

      get :index, { :year => "1666" }

      assert_response :success
      assigns[:newsitems].should == newsitems
      assigns[:title].should == "News of 1666"
      assigns[:last_updated].should == updated_at
    end

    context "when logged in" do
      it "should all news items in the year" do
        newsitems = mock("news items")
        updated_at = mock("updated at time")

        Newsitem.should_receive(:find_by_year).with(1492, :all).and_return(newsitems)
        newsitems.should_receive(:maximum).with(:updated_at).and_return(updated_at)

        get :index, { :year => "1492" }, user_session(:edit)

        assert_response :success
        assigns[:newsitems].should == newsitems
        assigns[:title].should == "News of 1492"
      end
    end
  end

  context "editing a news item" do
    it "should find the news item to be edited" do
      newsitem = mock_model(Newsitem)
      Newsitem.should_receive(:find).with("456").and_return(newsitem)

      get :edit, { :id => "456" }, user_session(:edit)

      response.should render_template("newsitems/edit")
      assigns[:newsitem].should == newsitem
    end

    it "should redirect to login when not logged in" do
      get :edit

      response.should redirect_to("/users/login")
    end
  end

  context "show action" do
    it "should show basic news item" do
      updated_at = mock("updated at")
      item = mock_model(Newsitem, :headline => "The Headline", :updated_at => updated_at)

      Newsitem.should_receive(:find).with(item.id).and_return(item)

      get :show, { :id => item.id }

      assert_response :success
      assigns[:newsitem].should == item
      assigns[:title].should == "The Headline"
      assigns[:last_updated].should == updated_at
    end

    it "should show more detail when logged in" do
      updated_at = mock("updated at")
      item = mock_model(Newsitem, :headline => "The Headline", :updated_at => updated_at)

      Newsitem.should_receive(:find).with(item.id).and_return(item)

      get :show, { :id => item.id }, user_session(:edit)

      assert_response :success
      assigns[:newsitem].should == item
      assigns[:title].should == "The Headline"
      assigns[:last_updated].should == updated_at
    end
  end

  context "create action" do
    it "should redirect when NOT logged in" do
      post :create

      response.should redirect_to(login_path)
    end

    it "should create a new news item" do
      newsitem = mock_model(Newsitem)

      Newsitem.should_receive(:new).
              with("user_id" => users(:jeremy).id, "params" => "values").
              and_return(newsitem)
      newsitem.should_receive(:save).and_return(true)

      post :create, { :newsitem => { :params => "values" } }, user_session(:edit)

      response.should redirect_to(newsitems_path)
    end

    it "should redirect when not saved" do
      newsitem = mock_model(Newsitem)

      Newsitem.should_receive(:new).
              with("user_id" => users(:jeremy).id, "params" => "values").
              and_return(newsitem)
      newsitem.should_receive(:save).and_return(false)

      post :create, { :newsitem => { :params => "values" } }, user_session(:edit)

      response.should render_template("newsitems/new")
    end
  end

  context "updating a newsitem" do
    it "should redirect when not logged in" do
      post :update

      response.should redirect_to("/users/login")
    end

    it "should do an update successfully" do
      newsitem = mock_model(Newsitem)

      Newsitem.should_receive(:find).with(newsitem.id).and_return(newsitem)
      newsitem.should_receive(:update_attributes).with("params" => "values").and_return(true)

      post :update,
           { :id => newsitem.id, :newsitem => { :params => "values" } },
           user_session(:edit)

      assigns[:newsitem] = newsitem
      response.should redirect_to("/newsitems/#{newsitem.id}")
    end

    it "should do fail an update" do
      newsitem = mock_model(Newsitem)

      Newsitem.should_receive(:find).with(newsitem.id).and_return(newsitem)
      newsitem.should_receive(:update_attributes).with("params" => "values").and_return(false)

      post :update,
           { :id => newsitem.id, :newsitem => { :params => "values" } },
           user_session(:edit)

      assigns[:newsitem] = newsitem
      response.should render_template("newsitems/edit")
    end
  end

end

describe NewsitemsController do
  render_views

  fixtures :newsitems
  user_fixtures

  describe "response to GET new" do
    it "should redirect when not logged in" do
      get :new

      response.should redirect_to(login_path)
    end


    context "when logged in" do
      it "should create new news item" do
        get :new, {}, user_session(:edit)

        assert_response :success
        assert_select "h1", "Create News Item"
        assert_select "form[action=/newsitems]" do
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

  context "destroy action" do
    context "when NOT logged in" do
      it "should redirect" do
        post :destroy, { :id => newsitems(:todays_news).id }

        response.should redirect_to(login_path)
        assert_equal 4, Newsitem.count, "should still have four news items"
      end
    end

    context "when logged in" do
      it "should destroy" do
        assert_not_nil Newsitem.find_by_headline("News of Today"), "sanity check"
        assert_equal 4, Newsitem.count

        post :destroy, { :id => newsitems(:todays_news).id, :listing => 'foobar' },
                user_session(:edit)

        response.should redirect_to(newsitems_path)
        assert_equal 3, Newsitem.count, "lost just one news item"
        assert_nil Newsitem.find_by_headline("News of Today")
      end
    end
  end

  #
  # Helpers
  #
  private

  def current_year
    newsitems(:todays_news).goes_live_at.year
  end

  def assert_date_entry(nth, label, date, field)
    assert_select "tr:nth-child(#{nth})" do
      assert_select "td", label
      assert_select "td select#newsitem_#{field}_1i"
      assert_select "td select#newsitem_#{field}_2i"
      assert_select "td select#newsitem_#{field}_3i"
    end
  end

  def assert_newsitem_entry(n, newsitem, listing)
    time_class = newsitem.is_current? ? "current-news" : "past-news"
    assert_select "tr[class=#{time_class}]:nth-child(#{n*2-1})" do
      assert_select "td a[href=/news/view/#{newsitem.id}]", newsitem.headline
    end
    assert_select "tr[class=#{time_class}]:nth-child(#{n*2})" do
      assert_select "td.goes-live-date", "posted on #{newsitem.goes_live_at.to_s(:news_posted)}"
    end
  end

  def assert_full_newsitem(newsitem)
    assert_select "div#news-item-#{newsitem.id}[class=news-item]" do
      assert_select "h2", newsitem.headline
      assert_select "p.goes-live-date", "Posted on #{newsitem.goes_live_at.to_s(:news_posted)}"
      assert_select "div.content", newsitem.content
      assert_select "p.more a[href=#top]", "back to top..."
    end
  end

end
