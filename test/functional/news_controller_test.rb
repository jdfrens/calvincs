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
    assert_equal 2007, news_item.expires_at.year
    assert_equal 12, news_item.expires_at.month
    assert_equal 31, news_item.expires_at.day
  end
  
  should "list current news items by default" do
    get :list
    assert_response :success
    assert_standard_layout
    assert_select "h2", "Current News"
    assert_select "ul#news-items" do
      assert_select "li", 2, "Only two *current* news items"
      assert_select "li", "News of Today"
      assert_select "li", "News of Today II"
    end
  end
  
  should "list all news items when requested" do
    get :list, :id => 'all'
    assert_response :success
    assert_standard_layout
    assert_select "h2", "All News"
    assert_select "ul#news-items" do
      assert_select "li", 3
      assert_select "li", "News of Today"
      assert_select "li", "News of Today II"
      assert_select "li", "News of Yesterday"
    end
  end  
  
end