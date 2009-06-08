require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EventsController do

  user_fixtures

  describe "listing events" do
    it "should set the right data and use the right template" do
      events = [mock_model(Event), mock_model(Event), mock_model(Event)]
      Event.should_receive(:upcoming).with().and_return(events)

      get :index

      assert_response :success
      assigns[:events].should equal(events)
      assert_template 'events/index'
    end

    describe "and the list view" do
      it "should display data for a complete event" do
        events = mock("array of events")
        Event.should_receive(:upcoming).and_return(events)

        get :index

        assert_response :success
        assigns[:events].should equal(events)
      end

    end
  end

  describe "showing an event" do
    it "should find event and show it" do
      last_updated = mock("last updated date")
      event = mock_model(Event, :updated_at => last_updated)
      Event.should_receive(:find).with(event.id.to_s).and_return(event)

      get :show, :id => event.id

      assert_response :success
      assert_template "events/show"
      assigns[:event].should equal(event)
      assigns[:last_updated].should equal(last_updated)
    end

    it "should redirect to list when viewing event that does not exist" do
      Event.should_receive(:find).with("666").and_raise(ActiveRecord::RecordNotFound)

      get :show, :id => "666"

      assert_response :redirect
      assert_redirected_to :action => :index
    end
  end

  describe "building a new event" do

    user_fixtures

    it "should have a new action with a form" do
      get :new, {}, user_session(:edit)

      assert_response :success
      response.should render_template("events/new")
    end

    it "should redirect when not logged in" do
      get :new

      response.should redirect_to(:controller => 'users', :action => 'login')
    end

    it "should create a new event" do
      params = { :event => mock("event params") }
      event = mock("event")

      Event.should_receive(:new_event).with(params[:event]).and_return(event)
      event.should_receive(:save).and_return(true)

      post :create, params, user_session(:edit)
      assigns[:event].should eql(event)
      response.should redirect_to(:action => "index")
    end

    it "should fail to create a new event" do
      params = { :event => mock("event params") }
      event = mock("event")

      Event.should_receive(:new_event).with(params[:event]).and_return(event)
      event.should_receive(:save).and_return(false)

      post :create, params, user_session(:edit)
      assigns[:event].should eql(event)
      response.should render_template("events/new")
    end

    it "should redirect create when not logged in" do
      get :create, {}

      response.should redirect_to(:controller => 'users', :action => 'login')
    end

  end

  context "editing an event" do
    it "should redirect to login when NOT logged in" do
      get :edit

      response.should redirect_to("/users/login")
    end

    it "should find the event and generate the form" do
      event = mock_model(Event)

      Event.should_receive(:find).with("123").and_return(event)

      get :edit, { :id => 123 }, user_session(:edit)

      response.should be_success
      assigns[:event].should == event
    end
  end

  context "updating an event" do
    it "should redirect to login when NOT logged in" do
      put :update

      response.should redirect_to("/users/login")
    end
    
    it "should save the modified event" do
      event = mock_model(Event)
      Event.should_receive(:find).with(event.id.to_s).and_return(event)

      event.should_receive(:update_attributes).with({ "foo" => "params" })
      event.should_receive(:save).and_return(true)

      put :update, { :id => event.id, :event => { "foo" => "params" } }, user_session(:edit)

      response.should redirect_to(events_path)
    end

    it "should save the modified colloquium" do
      event = mock_model(Colloquium)
      Event.should_receive(:find).with(event.id.to_s).and_return(event)

      event.should_receive(:update_attributes).with({ "foo" => "params" })
      event.should_receive(:save).and_return(true)

      put :update, { :id => event.id, :colloquium => { "foo" => "params" } }, user_session(:edit)

      response.should redirect_to(events_path)
    end

    it "should save the modified conference" do
      event = mock_model(Conference)
      Event.should_receive(:find).with(event.id.to_s).and_return(event)

      event.should_receive(:update_attributes).with({ "foo" => "params" })
      event.should_receive(:save).and_return(true)

      put :update, { :id => event.id, :conference => { "foo" => "params" } }, user_session(:edit)

      response.should redirect_to(events_path)
    end

    it "should re-edit the modified, invalid event" do
      event = mock_model(Event)
      Event.should_receive(:find).with(event.id.to_s).and_return(event)

      event.should_receive(:update_attributes).with({ "foo" => "params" })
      event.should_receive(:save).and_return(false)

      put :update, { :id => event.id, :event => { "foo" => "params" } }, user_session(:edit)

      response.should be_success
      response.should render_template("edit")
    end
  end
end
