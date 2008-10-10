require File.dirname(__FILE__) + '/../test_helper'
require 'event_controller'

# Re-raise errors caught by the controller.
class EventController; def rescue_action(e) raise e end; end

class EventControllerTest < Test::Unit::TestCase
  
  fixtures :events
  user_fixtures :events
  
  def setup
    @controller = EventController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  context "the index action" do
    should "redirect index to list" do
      get :index
      
      assert_response :redirect
      assert_redirected_to :action => :list
    end
  end
  
  context "listing events" do    
    should "set the right data and use the right template" do
      semester_events = [
        events(:old_colloquium), events(:old_conference),
        events(:todays_colloquium), events(:within_a_week_colloquium),
        events(:within_a_month_colloquium), events(:next_weeks_conference)
      ]
      Event.expects(:find_by_semester_of).with().returns(semester_events)

      get :list
      
      assert_response :success
      assert_equal semester_events, assigns(:events)
      assert_template 'event/list'
    end

    context "and the list view" do
      should "display data for a complete event" do
        get :list
 
        assert_response :success
        assert_standard_layout  # TODO: need date check?
        assert_select "h1", "Upcoming Events"
        assert_select "div#event-3" do
          assert_select "h2", "Colloquium of Today: Talk about Today!" do
            assert_select ".title .textilized-wop", "Colloquium of Today"
            assert_select "br", true
            assert_select ".subtitle .textilized-wop", "Talk about Today!"
          end
          assert_select "p.when", events(:todays_colloquium).start.to_s(:colloquium)
        end
      end

      should "display data for an event without optional fields" do
        get :list
 
        assert_response :success
        assert_standard_layout  # TODO: need date check?
        assert_select "div#event-6" do
          assert_select "h2", "Future Conference" do
            assert_select ".title .textilized-wop", "Future Conference"
            assert_select "br", false
            assert_select ".subtitle", false
          end
          assert_select "p.when", events(:next_weeks_conference).start.to_s(:colloquium)
        end
      end
    end
  end
  
  context "viewing an event" do
    should "does the right things" do
      event = events(:old_colloquium)
 
      get :view, :id => event.id
      
      assert_response :success
      assert_standard_layout
      # TODO: add timestamp columns, then add this next assertion
      # assert_equal event.updated_at, assigns(:last_updated)
      assert_equal event, assigns(:event)
      assert_template "event/view"
    end

    context "shows" do
      should "view a complete event" do
        event = events(:old_colloquium)
 
        get :view, :id => event.id
      
        assert_response :success
        assert_select "div#event-title" do
          assert_select "h1 .textilized-wop", event.title
          assert_select "h2#subtitle .textilized-wop", event.subtitle
        end
        assert_select "div#event-presenter .textilized-wop", event.presenter
        assert_select "div#event-description .textilized", event.description
      end

      should "view a minimal event" do
        event = events(:within_a_month_colloquium)
 
        get :view, :id => event.id
      
        assert_response :success
        assert_select "div#event-title" do
          assert_select "h1 .textilized-wop", event.title
          assert_select "h2#subtitle", false
        end
        assert_select "div#event-presenter", false
        assert_select "div#event-description .textilized", event.description
      end
    end
    
    should "redirect to list when viewing event that does not exist" do
      get :view, :id => "666"
      
      assert_response :redirect
      assert_redirected_to :action => :list
    end
  end
  
  context "building a new event" do
    should "have a new action with a form" do
      get :new, {}, user_session(:edit)
      
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
    
    should_redirect_to_login_when_NOT_logged_in :new
  end
end
