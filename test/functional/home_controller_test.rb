require File.dirname(__FILE__) + '/../test_helper'
require 'home_controller'

# Re-raise errors caught by the controller.
class HomeController; def rescue_action(e) raise e end; end

class HomeControllerTest < Test::Unit::TestCase
  
  fixtures :users, :groups, :privileges, :groups_privileges, :pages
  
  def setup
    @controller = HomeController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  should "have an index page" do
    get :index
    assert_response :success
    assert_home_page_layout
    assert_template 'home/index'
    assert_select "h1", "Computing at Calvin College"
    assert_select "p", "home page text written in textile"
    assert_select "p strong", "textile"
  end

  should "have an index page when logged in" do
    get :index, {}, user_session(:admin)
    assert_response :success
    assert_home_page_layout
    assert_template 'home/index'
    assert_select "h1", "Computing at Calvin College"
    assert_select "p", "home page text written in textile"
    assert_select "p strong", "textile"
    assert_select "a[href=/p/home_page]"
  end

  should "protect administration page" do
    get :administrate
    assert_redirected_to :controller => 'users', :action => 'login'
  end
      
  should "have an administration page" do
    get :administrate, {}, user_session(:admin)
    assert_user_privilege 1, 'admin'
    assert_response :success
    assert_standard_layout
    assert_template 'home/administrate'
    assert_select 'h1', "Master Administration"
    assert_select 'h2', "News and Events"
    assert_select "ul#news_administration" do
      assert_select "a[href=/news/list?filter=current]", /current/i 
      assert_select "a[href=/news/list?filter=all]", /all/i 
      assert_select "a[href=/news/new]", /create/i 
    end
    assert_select 'h2', "Webpages and Other Documents"
    assert_select "ul#content_administration" do
      assert_select "a[href=/page/list]", /list/i 
      assert_select "a[href=/page/create]", /create/i 
    end
    assert_select 'h2', "Courses"
    assert_select "ul#course_administration" do
      assert_select "a[href=/curriculum/list_courses]", /list/i 
      assert_select "a[href=/curriculum/new_course]", /create/i 
    end
  end
  
  #
  # Helpers
  #
  private 
  
  def assert_home_page_layout
    assert_standard_layout
    assert_equal assigns(:splash), pages(:home_splash)
    assert_equal assigns(:content), pages(:home_page)
    assert_select "div#content" do
      assert_select "div#splash" do
        assert_select "h1", 0, "*no* title in header"
      end
      assert_select "div#home_page" do
        assert_select "h1", pages(:home_page).title
      end
      assert_select "div#news", 1
    end
  end

end
