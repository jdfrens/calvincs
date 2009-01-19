require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HomeController do

  describe "responding to GET index" do

    it "should set a bunch of variables" do
      home_page = mock_model(Page)
      home_splash = mock_model(Page)
      news_items = [mock("news items")]
      todays_events = [mock("today's events")]
      this_weeks_events = [mock("this week's events")]
      last_updated = mock("last updated")

      Page.should_receive(:find_by_identifier).with('_home_page').and_return(home_page)
      Page.should_receive(:find_by_identifier).with('_home_splash').and_return(home_splash)
      NewsItem.should_receive(:find_current).and_return(news_items)
      Event.should_receive(:find_by_today).and_return(todays_events)
      Event.should_receive(:find_by_week_of).with(instance_of(Time)).and_return(this_weeks_events)
      controller.should_receive(:last_updated).with(news_items + [home_page, home_splash]).and_return(last_updated)

      get :index
      response.should be_success

      assigns[:content].should == home_page
      assigns[:splash].should == home_splash
      assigns[:news_items].should == news_items
      assigns[:todays_events].should == todays_events
      assigns[:this_weeks_events].should == this_weeks_events
      assigns[:last_updated].should == last_updated
    end

  end

  describe "responding to GET administrate" do
    user_fixtures

    it "should redirect if not editor" do
      get :administrate
      response.should redirect_to("http://test.host/users/login")
    end
    
    it "should succeed if editor" do
      get :administrate, {}, user_session(:edit)
      response.should be_success
    end

  end

end
