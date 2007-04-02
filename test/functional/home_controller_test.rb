require File.dirname(__FILE__) + '/../test_helper'
require 'home_controller'

# Re-raise errors caught by the controller.
class HomeController; def rescue_action(e) raise e end; end

class HomeControllerTest < Test::Unit::TestCase
  
  fixtures :users, :groups, :privileges, :groups_privileges, :news_items, :pages
  
  def setup
    @controller = HomeController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  should "have an index page" do
    get :index
    assert_response :success
    assert_home_page_assignments
    assert_home_page_layout
    assert_template 'home/index'
  end

  should "have an index page when logged in" do
    get :index, {}, user_session(:admin)
    assert_response :success
    assert_home_page_assignments
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
  
  def assert_home_page_assignments
    assert_equal pages(:home_splash), assigns(:splash)
    assert_equal pages(:home_page), assigns(:content)
    assert_equal NewsItem.find_current, assigns(:news_items)
  end
  
  def assert_home_page_layout
    assert_standard_layout
    assert_select "div#content" do
      assert_select "div#home_splash p:first-of-type",
          pages(:home_splash).content do
        assert_select "h1", 0, "*no* title in splash"
      end
      assert_select "div#home_page" do
        assert_select "h1", pages(:home_page).title
        assert_select "p", "home page text written in textile"
        assert_select "p strong", "textile"
      end
      assert_select "div#news" do
        assert_select "h1", "News"
        assert_select "ul li", 2
        NewsItem.find_current.each do |news_item|
        assert_select "li#news_item_#{news_item.id}"
          assert_select "span.news-title", news_item.title
          assert_select "a[href=/news/view/#{news_item.id}]", "more..."
        end
      end
    end
  end

end
