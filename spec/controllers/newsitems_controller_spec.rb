require 'spec_helper'

describe NewsitemsController do
  fixtures :newsitems
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

      Newsitem.should_receive(:find).with(newsitem.id.to_s).and_return(newsitem)

      get :edit, { :id => newsitem.id }, user_session(:edit)

      response.should render_template("newsitems/edit")
      assigns[:newsitem].should == newsitem
    end

    it "should redirect to login when not logged in" do
      get :edit, { :id => 456 }

      response.should redirect_to("/users/login")
    end
  end

  context "show action" do
    it "should show basic news item" do
      updated_at = mock("updated at")
      item = mock_model(Newsitem, :headline => "The Headline", :updated_at => updated_at)

      Newsitem.should_receive(:find).with(item.id.to_s).and_return(item)

      get :show, { :id => item.id }

      assert_response :success
      assigns[:newsitem].should == item
      assigns[:title].should == "The Headline"
      assigns[:last_updated].should == updated_at
    end

    it "should show more detail when logged in" do
      updated_at = mock("updated at")
      item = mock_model(Newsitem, :headline => "The Headline", :updated_at => updated_at)

      Newsitem.should_receive(:find).with(item.id.to_s).and_return(item)

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
      post :update, { :id => 666 }

      response.should redirect_to("/users/login")
    end

    it "should do an update successfully" do
      newsitem = mock_model(Newsitem)

      Newsitem.should_receive(:find).with(newsitem.id.to_s).and_return(newsitem)
      newsitem.should_receive(:update_attributes).with("params" => "values").and_return(true)

      post :update,
           { :id => newsitem.id, :newsitem => { :params => "values" } },
           user_session(:edit)

      assigns[:newsitem] = newsitem
      response.should redirect_to("/newsitems/#{newsitem.id}")
    end

    it "should do fail an update" do
      newsitem = mock_model(Newsitem)

      Newsitem.should_receive(:find).with(newsitem.id.to_s).and_return(newsitem)
      newsitem.should_receive(:update_attributes).with("params" => "values").and_return(false)

      post :update,
           { :id => newsitem.id, :newsitem => { :params => "values" } },
           user_session(:edit)

      assigns[:newsitem] = newsitem
      response.should render_template("newsitems/edit")
    end
  end

  describe "response to GET new" do
    it "should redirect when not logged in" do
      get :new

      response.should redirect_to(login_path)
    end

    context "when logged in" do
      it "should create new news item" do
        get :new, {}, user_session(:edit)

        response.should be_success
        response.should render_template("newsitems/new")
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

private

  def current_year
    newsitems(:todays_news).goes_live_at.year
  end

end
