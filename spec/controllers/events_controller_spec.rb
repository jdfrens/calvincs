require 'spec_helper'

describe EventsController do

  user_fixtures

  describe "listing events" do
    it "should list upcoming events" do
      events = mock("array of events")
      Event.should_receive(:upcoming).and_return(events)

      get :index

      assigns[:events].should equal(events)
      assigns[:title].should == "Upcoming Events"
      response.should be_success
      response.should render_template("index")
    end

    it "should list event years" do
      years = mock("array of years")
      Event.should_receive(:years_of_events).and_return(years)

      get :index, { :year => "all" }

      assigns[:years].should equal(years)
      assigns[:title].should == "Events Archive"
      response.should be_success
      response.should render_template("archive")
    end

    it "should list events by year" do
      events = mock("array of year's events")
      Event.should_receive(:by_year).with("1666").and_return(events)

      get :index, { :year => "1666" }

      assigns[:events] = events
      assigns[:title].should == "Events of 1666"
      response.should be_success
      response.should render_template("index")
    end
  end

  describe "showing an event" do
    it "should find event and show it" do
      last_updated = mock("last updated date")
      event = mock_model(Event, :updated_at => last_updated)

      Event.should_receive(:find).with(event.id).and_return(event)

      get :show, :id => event.id

      assert_response :success
      assert_template "events/show"
      assigns[:event].should equal(event)
      assigns[:last_updated].should equal(last_updated)
    end

    it "should redirect to list when viewing event that does not exist" do
      Event.should_receive(:find).with("666").and_raise(ActiveRecord::RecordNotFound)

      get :show, :id => "666"

      response.should redirect_to(events_path)
    end
  end

  describe "creating a new event" do

    user_fixtures

    it "should present a form for a new colloquium" do
      event = mock("event")
      start = mock("start")
      stop = mock("stop")

      Event.should_receive(:default_start_and_stop).and_return([start, stop])
      Event.should_receive(:new_event).
              with(:kind => "Colloquium", :descriptor => "colloquium",
                   :start => start, :stop => stop).
              and_return(event)

      get :new, { :kind => "Colloquium" }, user_session(:edit)

      assert_response :success
      response.should render_template("events/new")
    end

    it "should present a form for a new conference" do
      event = mock("event")
      start = mock("start")
      stop = mock("stop")

      Event.should_receive(:default_start_and_stop).and_return([start, stop])
      Event.should_receive(:new_event).
              with(:kind => "Conference", :descriptor => "conference",
                   :start => start, :stop => stop).
              and_return(event)

      get :new, { :kind => "Conference" }, user_session(:edit)

      assert_response :success
      response.should render_template("events/new")
    end

    it "should redirect when not logged in" do
      get :new

      response.should redirect_to(login_path)
    end

    it "should create a new colloquium" do
      params = { :colloquium => mock("event params") }
      event = mock("event")

      Event.should_receive(:new_event).with(params[:colloquium]).and_return(event)
      event.should_receive(:save).and_return(true)

      post :create, params, user_session(:edit)
      assigns[:event].should eql(event)
      response.should redirect_to(events_path)
    end

    it "should create a new conference" do
      params = { :conference => mock("event params") }
      event = mock("event")

      Event.should_receive(:new_event).with(params[:conference]).and_return(event)
      event.should_receive(:save).and_return(true)

      post :create, params, user_session(:edit)
      assigns[:event].should eql(event)
      response.should redirect_to(events_path)
    end

    it "should fail to create a new event" do
      params = { :colloquium => mock("event params") }
      event = mock("event")

      Event.should_receive(:new_event).with(params[:colloquium]).and_return(event)
      event.should_receive(:save).and_return(false)

      post :create, params, user_session(:edit)
      assigns[:event].should eql(event)
      response.should render_template("events/new")
    end

    it "should redirect create when not logged in" do
      get :create, {}

      response.should redirect_to(login_path)
    end

  end

  context "editing an event" do
    it "should redirect to login when NOT logged in" do
      get :edit, { :id => 123 }

      response.should redirect_to("/users/login")
    end

    it "should find the event and generate the form" do
      event = mock_model(Event)

      Event.should_receive(:find).with(event.id).and_return(event)

      get :edit, { :id => event.id }, user_session(:edit)

      response.should be_success
      assigns[:event].should == event
    end
  end

  context "updating an event" do
    it "should redirect to login when NOT logged in" do
      put :update, { :id => 666 }

      response.should redirect_to("/users/login")
    end

    it "should save the modified event" do
      event = mock_model(Event)

      Event.should_receive(:find).with(event.id).and_return(event)
      event.should_receive(:update_attributes).with({ "foo" => "params" })
      event.should_receive(:save).and_return(true)

      put :update, { :id => event.id, :event => { "foo" => "params" } }, user_session(:edit)

      response.should redirect_to(events_path)
    end

    it "should save the modified colloquium" do
      event = mock_model(Colloquium)

      Event.should_receive(:find).with(event.id).and_return(event)
      event.should_receive(:update_attributes).with({ "foo" => "params" })
      event.should_receive(:save).and_return(true)

      put :update, { :id => event.id, :colloquium => { "foo" => "params" } }, user_session(:edit)

      response.should redirect_to(events_path)
    end

    it "should save the modified conference" do
      event = mock_model(Conference)

      Event.should_receive(:find).with(event.id).and_return(event)
      event.should_receive(:update_attributes).with({ "foo" => "params" })
      event.should_receive(:save).and_return(true)

      put :update, { :id => event.id, :conference => { "foo" => "params" } }, user_session(:edit)

      response.should redirect_to(events_path)
    end

    it "should re-edit the modified, invalid event" do
      event = mock_model(Event)

      Event.should_receive(:find).with(event.id).and_return(event)
      event.should_receive(:update_attributes).with({ "foo" => "params" })
      event.should_receive(:save).and_return(false)

      put :update, { :id => event.id, :event => { "foo" => "params" } }, user_session(:edit)

      response.should be_success
      response.should render_template("edit")
    end
  end
end
