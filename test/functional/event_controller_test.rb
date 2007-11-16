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
  end

  context "the index should list upcoming events" do
    should "redirect index to list" do
      get :index
      
      assert_response :redirect
      assert_redirected_to :action => :list
    end
  end
  
  context "viewing an event" do
    should "view an event" do
      event = events(:old_colloquium)
      
      get :view, :id => event.id
      
      assert_response :success
      assert_select "div#event-title" do
        assert_select "h1", event.title
        assert_select "h2", event.subtitle
      end
      assert_select "div#event-description", event.description
    end
    
    should "redirect to list when viewing event that does not exist" do
      get :view, :id => "666"
      
      assert_response :redirect
      assert_redirected_to :action => :list
    end
  end
end
