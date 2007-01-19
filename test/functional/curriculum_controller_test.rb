require File.dirname(__FILE__) + '/../test_helper'
require 'curriculum_controller'

# Re-raise errors caught by the controller.
class CurriculumController; def rescue_action(e) raise e end; end

class CurriculumControllerTest < Test::Unit::TestCase
  fixtures :courses
  
  def setup
    @controller = CurriculumController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  should "redirect to course listing for index action" do
    get :index
    assert_redirected_to :action => 'list_courses'
  end
  
  should "get list of all courses" do
    get :list_courses
    assert_response :success
    assert_standard_layout
    assert_template 'curriculum/list_courses'
    assert_select "h1", "Course Listing"
    assert_select "ul#courses" do
      assert_select "li:nth-child(1)", "CS 108: Introduction to Programming"
      assert_select "li:nth-child(2)", "CS 214: Programming Languages"
      assert_select "li:nth-child(3)", "IS 337: Website Administration"
    end
  end
  
end
