require File.dirname(__FILE__) + '/../test_helper'
require 'home_controller'

# Re-raise errors caught by the controller.
class HomeController; def rescue_action(e) raise e end; end

class HomeControllerTest < Test::Unit::TestCase
  
  fixtures :users, :groups, :privileges, :groups_privileges
  
  def setup
    @controller = HomeController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  should "have an index page" do
    get :index
    assert_response :success
    assert_standard_layout
    assert_template 'home/index'
    assert_select "h1", "Computing at Calvin College"
    assert_select "p", "home page text"
  end

  should "protect administration page" do
    get :administrate
    assert_redirected_to :controller => 'users', :action => 'login'
  end
      
  should "have an administration page" do
    get :administrate, {}, { :current_user_id => 1 }
    assert_admin_user 1
    assert_response :success
    assert_standard_layout
    assert_template 'home/administrate'
    assert_select 'h1', "Master Administration"
    assert_select 'h2', "Courses"
    assert_select "ul#course_administration" do
      assert_select "a[href=/curriculum/list_courses]", /course list/i 
      assert_select "a[href=/curriculum/new_course]", /new course/i 
    end
    assert_select 'h2', "Documents"
    assert_select "ul#document_administration" do
      assert_select "a[href=/document/list]", /document list/i 
      assert_select "a[href=/document/create]", /new document/i 
    end
    assert_select 'h2', "News and Events"
  end

  #
  # Helpers
  #
  private
          
  def assert_admin_user(expected_id)
    actual_id = session[:current_user_id]
    assert_equal expected_id, actual_id
    user = User.find(actual_id)
    assert_not_nil user
    privilege = Privilege.find_by_name('admin')
    assert_not_nil privilege
    assert user.group.privileges.include?(privilege)
  end
  
end
