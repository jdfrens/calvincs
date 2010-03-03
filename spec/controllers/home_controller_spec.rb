require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HomeController do

  describe "responding to GET index" do
    it "should have the last modified depend on dates of news items" do
      content = mock_model(Page)
      splash_image = mock_model(Image)
      newsitems = [mock_model(Newsitem), mock_model(Newsitem), mock_model(Newsitem)]
      todays_events = [mock_model(Event), mock_model(Event), mock_model(Event)]
      this_weeks_events = [mock_model(Event), mock_model(Event), mock_model(Event)]
      last_updated = mock("last updated")

      Page.should_receive(:find_by_identifier).with('_home_page').and_return(content)
      Image.should_receive(:pick_random).with('homepage').and_return(splash_image)
      Newsitem.should_receive(:find_current).and_return(newsitems)
      Event.should_receive(:find_by_today).and_return(todays_events)
      Event.should_receive(:within_week).and_return(this_weeks_events)
      controller.should_receive(:last_updated).
        with(newsitems + [content]).
        and_return(last_updated)
        
      get :index

      response.should be_success
      assigns[:content].should equal(content)
      assigns[:splash_image].should equal(splash_image)
      assigns[:newsitems].should equal(newsitems)
      assigns[:todays_events].should equal(todays_events)
      assigns[:this_weeks_events].should equal(this_weeks_events)
      assigns[:last_updated].should equal(last_updated)
    end

    it "should redirect when there's no homepage image" do
      Page.should_receive(:find_by_identifier).with('_home_page').and_return(mock_model(Page))
      Image.should_receive(:pick_random).with('homepage').and_return(nil)

      get :index
    end

    it "should redirect when _home_page is not defined" do
      Page.should_receive(:find_by_identifier).with('_home_page').and_return(nil)

      get :index

      response.should redirect_to(:controller => "pages", :action => "new", :id => "_home_page")
    end
  end

  describe "the administration page" do

    user_fixtures

    it "should redirect when not logged in" do
      get :administrate
        
      response.should redirect_to(login_path)
    end

    it "should administrate when logged in" do
      get :administrate, {}, user_session(:edit)

      response.should be_success
      response.should render_template("home/administrate")
    end
  end

  describe "the atom feed" do

    it "should render atom" do
      get :feed, :format => "atom"

      response.should be_success
      response.should render_template("home/feed.atom")
    end

    it "should find news items" do
      newsitems = mock("news items")
      todays_events = mock("today's events")
      weeks_events = mock("week's events")
      updated_at = mock("updated at")

      Newsitem.should_receive(:find_current).and_return(newsitems)
      newsitems.should_receive(:maximum).with(:updated_at).and_return(updated_at)
      Event.should_receive(:find_by_today).and_return(todays_events)
      Event.should_receive(:within_week).and_return(weeks_events)

      get :feed, :format => "atom"

      assigns[:newsitems].should == newsitems
      assigns[:todays_events].should == todays_events
      assigns[:weeks_events].should == weeks_events
      assigns[:updated_at].should == updated_at   
    end
  end
end
