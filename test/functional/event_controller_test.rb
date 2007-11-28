require File.dirname(__FILE__) + '/../test_helper'
require 'event_controller'

# Re-raise errors caught by the controller.
class EventController; def rescue_action(e) raise e end; end

class EventControllerTest < Test::Unit::TestCase
  
  fixtures :events
  
  def setup
    @controller = EventController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    reset_text_processing
  end

  context "the index action" do
    should "redirect index to list" do
      get :index
      
      assert_response :redirect
      assert_redirected_to :action => :list
    end
  end
  
  context "listing events" do
    should "list upcoming events by default" do
      get :list
      
      assert_response :success
      assert_standard_layout  # TODO: need date check?
      
      assert_select "h1", "Upcoming Events"
      assert_select "h2", "Today's Colloquium"
      assert_select "h2", "Six Days from Now"
      assert_select "h2", "Eight Days from Now"
      assert_select "h2", "Future Conference"
    end
  end
  
  context "viewing an event" do
    should "view an event" do
      event = events(:old_colloquium)
 
      get :view, :id => event.id
      
      assert_response :success
      assert_standard_layout  # TODO: need date check?
      
      assert_select "div#event-title" do
        assert_select "h1", event.title
        assert_html_escaped event.title
        assert_select "h2", event.subtitle
        assert_html_escaped event.subtitle
      end
      assert_select "div#event-description", event.description
      assert_textilized event.description
    end
    
    should "redirect to list when viewing event that does not exist" do
      get :view, :id => "666"
      
      assert_response :redirect
      assert_redirected_to :action => :list
    end
  end
  
  context "building a new event" do
    should "have a new action with a form" do
      get :new
      
      assert_response :success
      assert_standard_layout
      
      assert_select "h1", "New Event"
      assert_select "form[action=/event/create]" do
        assert_select "select#event_type" do
          assert_select "option", 2
          assert_select "option", /colloquium/i
          assert_select "option", /conference/i
        end
        assert_select "input#event_title"
        assert_select "input#event_subtitle"
        assert_select "textarea#event_description"
        assert_datetime_selector "event", "start"
        assert_select "input#event_length"
        assert_select "input[type=submit]"
      end
    end
  end
end
