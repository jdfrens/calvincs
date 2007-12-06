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
      assert_select "h2#event-3" do
        assert_select ".title .fake-textilized-without-paragraph", "Today's Colloquium"
        assert_select ".subtitle .fake-textilized-without-paragraph", "Talk about Today!"
      end
      assert_select "h2#event-4" do
        assert_select ".title .fake-textilized-without-paragraph", "Six Days from Now"
        assert_select ".subtitle .fake-textilized-without-paragraph", "Talk about Six Days!"
      end
      assert_select "h2#event-5" do
        assert_select ".title .fake-textilized-without-paragraph", "Eight Days from Now"
        assert_select ".subtitle", false
      end
      assert_select "h2#event-6" do
        assert_select ".title .fake-textilized-without-paragraph", "Future Conference"
        assert_select ".subtitle", false
      end
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
