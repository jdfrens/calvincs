require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EventController do
  
  describe "the index action" do
    it "should redirect index to list" do
      get :index
      
      assert_response :redirect
      assert_redirected_to :action => :list
    end
  end
  
  describe "listing events" do    
    it "should set the right data and use the right template" do
      events = [mock_model(Event), mock_model(Event), mock_model(Event)]
      Event.should_receive(:find_by_semester_of).with().and_return(events)

      get :list
      
      assert_response :success
      assigns[:events].should equal(events)
      assert_template 'event/list'
    end

    describe "and the list view" do
      it "should display data for a complete event" do
        events = mock("array of events")
        Event.should_receive(:find_by_semester_of).and_return(events)
        
        get :list
 
        assert_response :success
        assigns[:events].should equal(events)
      end

    end
  end
  
  describe "viewing an event" do
    it "should find event and view it" do
      event = mock_model(Event)
      Event.should_receive(:find).with(event.id.to_s).and_return(event)
 
      get :view, :id => event.id
      
      assert_response :success
      assert_template "event/view"
      assigns[:event].should equal(event)
      # TODO: add timestamp columns, then add this next assertion
      #   assigns[:last_updated].should equal(last_updated)
    end

    it "should redirect to list when viewing event that does not exist" do
      Event.should_receive(:find).with("666").and_raise(ActiveRecord::RecordNotFound)

      get :view, :id => "666"
      
      assert_response :redirect
      assert_redirected_to :action => :list
    end
  end
  
  describe "building a new event" do
    it "should have a new action with a form" do
      get :new, {}, mock_user_session(:edit)
      
      assert_response :success
      response.should render_template("event/new")
    end

    it "should redirect when not logged in" do
      pending
      get :new

      response.should redirect_to(:controller => 'users', :action => 'login')
    end

    it "should create a new event" do
      params = { :event => mock("event params") }
      event = mock("event")

      Event.should_receive(:new_event).with(params[:event]).and_return(event)
      event.should_receive(:save).and_return(true)

      post :create, params, mock_user_session(:edit)
      assigns[:event].should eql(event)
      response.should redirect_to(:action => "list") 
    end

    it "should fail to create a new event" do
      params = { :event => mock("event params") }
      event = mock("event")

      Event.should_receive(:new_event).with(params[:event]).and_return(event)
      event.should_receive(:save).and_return(false)

      post :create, params, mock_user_session(:edit)
      assigns[:event].should eql(event)
      response.should render_template("event/new")
    end

    it "should redirect create when not logged in" do
      pending
      get :create, mock("params")

      response.should redirect_to(:controller => 'users', :action => 'login')
    end

  end
end
