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

  def test_index
    get :index
    
    assert_response :success
    assert_home_page_layout
    
    assert_home_page_assignments
    assert_template 'home/index'
  end
  
  def test_index_last_modified_also_depends_on_news_items
    get :index
    
    assert_response :success
    assert_standard_layout :last_updated => pages(:home_page).updated_at
    
    news_item = news_items(:todays_news)
    news_item.teaser = 'changed for new updated_at'
    news_item.save!
    news_item.reload
    
    get :index
    
    assert_response :success
    assert_standard_layout :last_updated => news_item.updated_at
  end

  def test_index_when_logged_in
    get :index, {}, user_session(:edit)
    
    assert_response :success
    assert_home_page_layout
    
    assert_home_page_assignments
    assert_template 'home/index'
    
    assert_select "h1", "Computing at Calvin College"
    assert_select "p", "home page text written in textile"
    assert_select "p strong", "textile"
    assert_select "a[href=/p/_home_page]"
  end

  def test_administrate_redirects_when_NOT_logged_in
    get :administrate
    assert_redirected_to :controller => 'users', :action => 'login'
  end
      
  def test_administration_page
    get :administrate, {}, user_session(:edit)

    assert_response :success
    assert_standard_layout
    assert_template 'home/administrate'
    assert_select 'h1', "Master Administration"
    assert_news_menu
    assert_page_menu
    assert_album_menu
    assert_course_menu
  end
  
  #
  # Helpers
  #
  private 
  
  def assert_news_menu
    assert_select 'h2', "News and Events"
    assert_select "ul#news_administration" do
      assert_select "a[href=/news/list/current]", /current/i 
      assert_select "a[href=/news/list/all]", /all/i 
      assert_select "a[href=/news/new]", /create/i 
    end
  end
  
  def assert_page_menu
    assert_select 'h2', "Webpages and Other Documents"
    assert_select "ul#content_administration" do
      assert_select "a[href=/page/list]", /list/i 
      assert_select "a[href=/page/create]", /create/i 
    end
  end
  
  def assert_album_menu
    assert_select "h2", "Image Album"
    assert_select "ul#album_administration" do
      assert_select "a[href=/album/list]", /list images/i
      assert_select "a[href=/album/create]", /add image/i
    end
  end

  def assert_course_menu
    assert_select 'h2', "Courses"
    assert_select "ul#course_administration" do
      assert_select "a[href=/curriculum/list_courses]", /list/i 
      assert_select "a[href=/curriculum/new_course]", /create/i 
    end
  end
  
  def assert_home_page_assignments
    assert_equal pages(:home_splash), assigns(:splash)
    assert_equal pages(:home_page), assigns(:content)
    assert_equal NewsItem.find_current, assigns(:news_items)
    assert_equal pages(:home_page).updated_at, assigns(:last_updated)
  end
  
  def assert_home_page_layout
    assert_standard_layout :last_updated => pages(:home_page).updated_at
    assert_select "div#content" do
      assert_select "div#home_splash p:first-of-type", pages(:home_splash).content do
        assert_select "h1", 0, "*no* title in splash"
      end
      assert_select "div#home_page" do
        assert_select "h1", pages(:home_page).title
        assert_select "p", "home page text written in textile"
        assert_select "p strong", "textile"
      end
      assert_select "div#news" do
        assert_select "h1", "News"
        assert_select "ul li", :count => (NewsItem.find_current.size + 1)
        NewsItem.find_current.each do |news_item|
          assert_select "li#news_item_#{news_item.id}"
          assert_select "span.news-teaser", strip_textile(news_item.teaser)
          assert_select "a.more[href=/news#news_item_#{news_item.id}]", "more..."
        end
        assert_select "ul li a.more[href=/news]", "other news..."
      end
    end
  end

end
