require File.dirname(__FILE__) + '/../test_helper'
require 'news_controller'

# Re-raise errors caught by the controller.
class NewsController; def rescue_action(e) raise e end; end

class NewsControllerTest < Test::Unit::TestCase
  
  fixtures :news_items, :users
  
  def setup
    @controller = NewsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  should "redirect when NOT logged in and creating new news item" do
    get :new
    assert_redirected_to_login
  end
  
  should "display form when creating new news item and logged in" do
    get :new, {}, { :current_user_id => 1 }
    assert_response :success
    assert_standard_layout
    assert_select "h1", "Create News Item"
    assert_select "form[action=/news/save]" do
      assert_select "tr:nth-child(1)" do
        assert_select "td", /title/i
        assert_select "td input[type=text]"
      end
      assert_select "tr:nth-child(2)" do
        assert_select "td", /content/i
        assert_select "td textarea"
      end
      assert_select "tr:nth-child(3)" do
        assert_select "td", /expires/i
        date = 1.month.from_now
        assert_select "td select#news_item_expires_at_1i" do
          assert_select "option[value=#{date.year}][selected=selected]"
        end
        assert_select "td select#news_item_expires_at_2i" do
          assert_select "option[value=#{date.month}][selected=selected]"
        end
        assert_select "td select#news_item_expires_at_3i" do
          assert_select "option[value=#{date.day}][selected=selected]"
        end
      end
      assert_select "input[type=submit]"
    end
  end  
  
  should "redirect when NOT logged in and saving new news item" do
    post :save, :news_item => {
        :title => 'News Title', :content => 'News Content',
        :expires_at => [2007, 12, 31]
    }
    assert_redirected_to_login
  end
  
  should "save news item when logged in" do
    post :save, { :news_item => {
        :title => 'News Title', :content => 'News Content',
        'expires_at(1i)' => '2007', 'expires_at(2i)' => '12',
        'expires_at(3i)' => '31',
    }}, { :current_user_id => 1 }
    assert_redirected_to :controller => 'news', :action => 'list'

    news_item = NewsItem.find_by_title('News Title')
    assert_not_nil news_item
    assert_equal 'News Title', news_item.title
    assert_equal 'News Content', news_item.content
    assert_equal Time.local(2007, 12, 31), news_item.expires_at
  end
  
  should "fail to save BAD news item when logged in" do
    post :save, { :news_item => {
        :title => '', :content => ''
    }}, { :current_user_id => 1 }
    assert_response :success
    assert !flash.empty?
    assert_equal 'Invalid values for the news item', flash[:error]
    assert_equal 3, NewsItem.find(:all).size,
        "should have only three news items still"
  end
  
  should "list current news items by default" do
    get :list
    assert_response :success
    assert_standard_layout
    assert_select "h2", "Current News"
    assert_select_news_links
    assert_select "table[summary=news items]" do
      assert_select "tr", 2, "Only two *current* news items"
      assert_news_item_entry 1, news_items(:todays_news)
      assert_news_item_entry 2, news_items(:another_todays_news)
    end
    assert_select "a[href=/news/new]", 0
  end
  
  should "list all news items when requested" do
    get :list, :id => 'all'
    assert_response :success
    assert_standard_layout
    assert_select "h2", "All News"
    assert_select_news_links
    assert_select "table[summary=news items]" do
      assert_select "tr", 3
      assert_news_item_entry 1, news_items(:todays_news)
      assert_news_item_entry 2, news_items(:another_todays_news)
      assert_news_item_entry 3, news_items(:past_news)
    end
    assert_select "a[href=/news/new]", 0
  end  
  
  should "list all news items when requested and editting controls when logged in" do
    get :list, { :id => 'all' }, { :current_user_id => 1 }
    assert_response :success
    assert_standard_layout
    assert_select "h2", "All News"
    assert_select_news_links
    assert_select "table[summary=news items]" do
      assert_select "tr", 3
      assert_news_item_entry 1, news_items(:todays_news)
      assert_news_item_entry 2, news_items(:another_todays_news)
      assert_news_item_entry 3, news_items(:past_news)
    end
    assert_select "a[href=/news/new]", "Create new news item"
  end
  
  should "redirect when trying to destroy news item and NOT logged in" do
    post :destroy, { :id => news_items(:todays_news).id }
    assert_redirected_to_login
    assert_equal 3, NewsItem.find(:all).size, "still have three news items"
  end

  should "destroy news item when logged in" do
    assert_not_nil NewsItem.find_by_title("News of Today"), "sanity check"
    post :destroy, { :id => news_items(:todays_news).id },
        { :current_user_id => 1 }
    assert_redirected_to :controller => 'news', :action => 'list'
    assert_equal 2, NewsItem.find(:all).size, "lost just one news item"
    assert_nil NewsItem.find_by_title("News of Today")
  end  
  
  #
  # Helpers
  #
  private
  
  def assert_news_item_entry(nth, news_item)
    time_class = news_item.is_current? ? "current-news" : "past-news"
    assert_select "tr[class=#{time_class}]:nth-child(#{nth})" do
      assert_select "td a[href=/news/view/#{news_item.id}]", news_item.title
    end
    if is_logged_in
      assert_select "form[action=/news/destroy/#{news_item.id}]" do
        assert_select "input[value=Destroy]", 1, "should have destroy button"
      end
    end
  end
  
  def assert_select_news_links
    assert_select "a[href=/news/list]", /current news/i
    assert_select "a[href=/news/list/all]", /all news/i
  end
  
end
