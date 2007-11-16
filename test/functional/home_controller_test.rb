require File.dirname(__FILE__) + '/../test_helper'
require 'home_controller'

# Re-raise errors caught by the controller.
class HomeController; def rescue_action(e) raise e end; end

class HomeControllerTest < Test::Unit::TestCase
  
  fixtures  :news_items, :events, :pages
  user_fixtures
  
  def setup
    @controller = HomeController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  context "exercising the index action" do
    should "have a normal index page" do
      get :index

      assert_response :success
      assert_home_page_layout

      assert_home_page_assignments
      assert_template 'home/index'
    end

    should "have the last modified depend on dates of news items" do
      get :index

      assert_response :success
      assert_standard_layout :last_updated => pages(:home_page).updated_at, :menu => :home

      news_item = news_items(:todays_news)
      news_item.teaser = 'changed for new updated_at'
      news_item.save!
      news_item.reload

      get :index

      assert_response :success
      assert_standard_layout :last_updated => news_item.updated_at, :menu => :home
    end

    should "see a different index page when logged in" do
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
  end
  
  context "the administration page" do
    should "redirect when not logged in" do
      get :administrate
      assert_redirected_to :controller => 'users', :action => 'login'
    end

    should "administrate when logged in" do
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
  end
  
  #
  # Helpers
  #
  private 
  
  def assert_news_menu
    assert_select 'h2', "News and Events"
    assert_select "ul#news_administration" do
      assert_select "a[href=/news/list]", /list and edit/i
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
    assert_equal Event.find_by_today, assigns(:todays_events)
    assert_equal Event.find_by_week_of(Time.now), assigns(:this_weeks_events)
    assert_equal pages(:home_page).updated_at, assigns(:last_updated)
  end
  
  def assert_home_page_layout
    assert_standard_layout :last_updated => pages(:home_page).updated_at, :menu => :home
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
        assert_select "ul li", :count => (NewsItem.find_current.size + Event.find_by_today.size + Event.find_by_week_of.size + 1)
        Event.find_by_today.each do |event|
          assert_select "li#event_#{event.id}" do
            assert_select "strong", "#{event.descriptor.capitalize} today!"
            assert_select "span", event.title
            assert_select "a.more[href=/events#event-#{event.id}]", "more..."
          end
        end
        Event.find_by_week_of.each do |event|
          assert_select "li#event_#{event.id}" do
            assert_select "strong", "#{event.descriptor.capitalize} this week!"
            assert_select "span", event.title
            assert_select "a.more[href=/events#event-#{event.id}]", "more..."
          end
        end
        NewsItem.find_current.each do |news_item|
          assert_select "li#news_item_#{news_item.id}"
          assert_select "span.news-teaser", strip_textile(news_item.teaser)
          assert_select "a.more[href=/news#news-item-#{news_item.id}]", "more..."
        end
        assert_select "ul li a.more[href=/news]", "other news..."
      end
    end
  end

end
