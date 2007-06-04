require File.dirname(__FILE__) + '/../test_helper'
require 'news_controller'

# Re-raise errors caught by the controller.
class NewsController; def rescue_action(e) raise e end; end

class NewsControllerTest < Test::Unit::TestCase
  
  fixtures :news_items
  user_fixtures
  
  def setup
    @controller = NewsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_index
    get :index
    assert_response :success
    assert_standard_layout
    assert_select "h1", "Current News"
    assert_full_news_item news_items(:another_todays_news)
    assert_full_news_item news_items(:todays_news), [ "today" ]
  end
  
  should "redirect when NOT logged in and creating new news item" do
    get :new
    assert_redirected_to_login
  end
  
  should "display form when creating new news item and logged in" do
    get :new, {}, user_session(:admin)
    assert_response :success
    assert_standard_layout
    assert_select "h1", "Create News Item"
    assert_select "form[action=/news/save]" do
      assert_select "tr:nth-child(1)" do
        assert_select "td", /headline/i
        assert_select "td input[type=text]"
      end
      assert_select "tr:nth-child(2)" do
        assert_select "td", /teaser/i
        assert_select "td input[type=text]"
      end
      assert_select "tr:nth-child(3)" do
        assert_select "td", /content/i
        assert_select "td textarea"
      end
      assert_date_entry(4, /goes live/i, Time.now, "goes_live_at")
      assert_date_entry(5, /expires/i, 1.month.from_now, "expires_at")
      assert_select "input[type=submit]"
    end
  end  
  
  should "redirect when NOT logged in and saving new news item" do
    post :save, :news_item => {
      :headline => 'News Headline', :content => 'News Content',
      :expires_at => [2007, 12, 31]
    }
    assert_redirected_to_login
  end
  
  should "save new news item when logged in" do
    post :save, { :news_item => {
        :headline => 'News Headline',
        :teaser => 'Brief Description', :content => 'News Content',
        'goes_live_at(1i)' => '2007', 'goes_live_at(2i)' => '11',
        'goes_live_at(3i)' => '15',
        'expires_at(1i)' => '2007', 'expires_at(2i)' => '12',
        'expires_at(3i)' => '31',
      }}, user_session(:admin)
    assert_redirected_to :controller => 'news', :action => 'list'
    
    news_item = NewsItem.find_by_headline('News Headline')
    assert_not_nil news_item
    assert_equal 'News Headline', news_item.headline
    assert_equal 'News Content', news_item.content
    assert_equal Time.local(2007, 11, 15), news_item.goes_live_at
    assert_equal Time.local(2007, 12, 31), news_item.expires_at
  end
  
  should "fail to save BAD news item when logged in" do
    post :save, { :news_item => {
        :headline => '', :content => ''
      }}, user_session(:admin)
    assert_response :success
    assert !flash.empty?
    assert_equal 'Invalid values for the news item', flash[:error]
    assert_equal 4, NewsItem.find(:all).size,
        "should have only four news items still"
  end
  
  def test_list_should_redirect_when_not_given_an_id
    get :list
    assert_response :redirect
    assert_redirected_to :action => "list", :id => "current"
  end
  
  def test_list_should_list_current_news_items
    get :list, { :id => "current" }

    assert_response :success
    assert_standard_layout
    assert_news_listing
    assert_select "div#newsItems table[summary=news items]" do
      assert_select "tr", 2, "Only two *current* news items"
      assert_news_item_entry 1, news_items(:todays_news), "current"
      assert_news_item_entry 2, news_items(:another_todays_news), "current"
    end
  end
  
  should "list current news items when explicitly requested" do
    get :list, { :id => 'current' }
    
    assert_response :success
    assert_standard_layout
    assert_news_listing
    assert_select "div#newsItems table[summary=news items]" do
      assert_select "tr", 2, "Only two *current* news items"
      assert_news_item_entry 1, news_items(:todays_news), "current"
      assert_news_item_entry 2, news_items(:another_todays_news), "current"
    end
  end
  
  should "list all news items when requested" do
    get :list, :id => 'all'
    
    assert_response :success
    assert_standard_layout
    assert_news_listing
    assert_select "div#newsItems table[summary=news items]" do
      assert_select "tr", 4
      assert_news_item_entry 1, news_items(:todays_news), "all"
      assert_news_item_entry 2, news_items(:another_todays_news), "all"
      assert_news_item_entry 3, news_items(:future_news), "all"
      assert_news_item_entry 4, news_items(:past_news), "all"
    end
  end  
  
  should "list: all news items, editting controls, logged in" do
    get :list, { :id => 'all' }, user_session(:admin)
    assert_response :success
    assert_standard_layout
    assert_news_listing
    assert_select "div#newsItems table[summary=news items]" do
      assert_select "tr", 4
      assert_news_item_entry 1, news_items(:todays_news), "all"
      assert_news_item_entry 2, news_items(:another_todays_news), "all"
      assert_news_item_entry 3, news_items(:future_news), "all"
      assert_news_item_entry 4, news_items(:past_news), "all"
    end
  end
  
  should "view a news item when NOT logged in" do
    get :view, { :id => news_items(:todays_news) }
    assert_response :success
    assert_select "h1", news_items(:todays_news).headline
    assert_select "div#news_item_teaser p", news_items(:todays_news).teaser
    assert_select "div#news_item_content p", "Something happened today."
    assert_select "div#news_item_content p strong", "today",
        "content should be Textiled"
        
    # no admin stuff
    assert_select "form[action=/news/update_news_content/3]", 0
    assert_select "p#expires_at", 0
  end
  
  def test_view_a_news_item_WHEN_logged_in
    item = news_items(:todays_news)
    id = item.id
    get :view, { :id => id }, user_session(:admin)
    
    assert_response :success
    
    assert_select "h1 span#news_item_headline_#{id}_in_place_editor", item.headline
    assert_select "div#content h1 input#edit_headline", 1
    
    assert_select "div#news_item_teaser span#news_item_teaser_#{id}_in_place_editor", item.teaser
    assert_select "div#news_item_teaser input#edit_teaser", 1

    assert_select "div#news_item_content p", "Something happened today."
    assert_select "div#news_item_content p strong", "today",
        "content should be Textiled"
        
    assert_link_to_markup_help
    assert_select "form[action=/news/update_news_item_content/#{id}]" do
      assert_select "textarea#news_item_content", item.content
      assert_select "input[type=submit][value=Update content]"
    end

    assert_select "p#goes_live_at strong", "Goes live:"
    assert_select "p#goes_live_at span#news_item_goes_live_at_formatted_#{id}_in_place_editor",
        item.goes_live_at_formatted

    assert_select "p#expires_at strong", "Expires:"
    assert_select "p#expires_at span#news_item_expires_at_formatted_#{id}_in_place_editor",
        item.expires_at_formatted
  end
  
  should "change headline of news item" do
    xhr :get, :set_news_item_headline,
      { :id => news_items(:todays_news).id, :value => 'New Headline' },
      user_session(:admin)
    assert_response :success
    assert_equal "New Headline", @response.body
    
    assert_equal 'New Headline', NewsItem.find(news_items(:todays_news).id).headline
  end
  
  should "fail to change headline when NOT logged in" do
    xhr :get, :set_news_item_headline, :id => news_items(:todays_news).id, :value => 'New HeadLine'
    assert_redirected_to_login
    assert_equal "News of Today", news_items(:todays_news).headline,
      'headline remains unchanged'
  end
  
  should "change teaser of news item" do
    xhr :get, :set_news_item_teaser,
      { :id => news_items(:todays_news).id, :value => 'Teaser of Newness' },
      user_session(:admin)
    assert_response :success
    assert_equal "Teaser of Newness", @response.body
    
    assert_equal 'Teaser of Newness', NewsItem.find(news_items(:todays_news).id).teaser
  end
  
  should "fail to change teaser when NOT logged in" do
    xhr :get, :set_news_item_teaser, :id => news_items(:todays_news).id, :value => 'Teaser Teaser'
    assert_redirected_to_login
    assert_equal "Some teaser.", news_items(:todays_news).teaser,
      'teaser remains unchanged'
  end
  
  def test_update_news_item_content
    item = news_items(:todays_news)
    xhr :get, :update_news_item_content,
        { :id => item.id, :news_item => { :content => 'News that is *fit* to print.' } },
        user_session(:admin)
        
    assert_response :success
    assert_select_rjs :replace_html, "news_item_content" do
      assert_select "p", "News that is fit to print."
      assert_select "strong", "fit"
    end
    
    item.reload
    assert_equal 'News that is *fit* to print.', item.content
  end
  
  def test_update_news_item_content_fails_when_NOT_logged_in
    item = news_items(:todays_news)
    original_content = item.content
    xhr :get, :update_news_item_content,
        { :id => item.id, :news_item => { :content => 'foobar!' } }
        
    assert_redirected_to_login
    item.reload
    assert_equal original_content, item.content
  end
    
  def test_set_goes_live_of_news_item
    item = news_items(:todays_news)
    xhr :get, :set_news_item_goes_live_at_formatted,
        { :id => item.id, :value => '01/05/2007' }, user_session(:admin)
        
    assert_response :success
    assert_equal '01/05/2007', @response.body
    item.reload
    assert_equal '01/05/2007', item.goes_live_at_formatted
  end
  
  should "fail to change goes-live when NOT logged in" do
    item = news_items(:todays_news)
    original_date = item.goes_live_at
    xhr :get, :set_news_item_goes_live_at_formatted,
        { :id => news_items(:todays_news).id, :value => '01/05/2007' }
    assert_redirected_to_login
    item.reload
    assert_equal original_date, item.goes_live_at, 'goes-live remains unchanged'
  end
  
  should "change expires-at of news item" do
    item = news_items(:todays_news)
    xhr :get, :set_news_item_expires_at_formatted,
        { :id => item.id, :value => '01/05/2007' }, user_session(:admin)
    assert_response :success
    assert_equal '01/05/2007', @response.body
    item.reload
    assert_equal '01/05/2007', item.expires_at_formatted
  end
  
  should "fail to change expires-at when NOT logged in" do
    item = news_items(:todays_news)
    original_date = item.expires_at
    xhr :get, :set_news_item_expires_at_formatted,
        { :id => item.id, :value => '01/05/2007' }
    assert_redirected_to_login
    item.reload
    assert_equal original_date, item.expires_at, 'expires-at remains unchanged'
  end
  
  should "redirect when trying to destroy news item and NOT logged in" do
    post :destroy, { :id => news_items(:todays_news).id }
    assert_redirected_to_login
    assert_equal 4, NewsItem.find(:all).size, "should still have four news items"
  end
  
  should "destroy news item when logged in" do
    assert_not_nil NewsItem.find_by_headline("News of Today"), "sanity check"
    assert_equal 4, NewsItem.find(:all).size
    
    post :destroy, { :id => news_items(:todays_news).id, :listing => 'foobar' }, user_session(:admin)
    
    assert_redirected_to :controller => 'news', :action => 'list', :id => 'foobar'
    assert_equal 3, NewsItem.find(:all).size, "lost just one news item"
    assert_nil NewsItem.find_by_headline("News of Today")
  end
  
  #
  # Helpers
  #
  private
  
  def assert_date_entry(nth, label, date, field)
    assert_select "tr:nth-child(#{nth})" do
      assert_select "td", label
      assert_select "td select#news_item_#{field}_1i" do
        assert_select "option[value=#{date.year}][selected=selected]"
      end
      assert_select "td select#news_item_#{field}_2i" do
        assert_select "option[value=#{date.month}][selected=selected]"
      end
      assert_select "td select#news_item_#{field}_3i" do
        assert_select "option[value=#{date.day}][selected=selected]"
      end
    end
  end
  
  def assert_news_item_entry(nth, news_item, listing)
    time_class = news_item.is_current? ? "current-news" : "past-news"
    assert_select "tr[class=#{time_class}]:nth-child(#{nth})" do
      assert_select "td a[href=/news/view/#{news_item.id}]", news_item.headline
    end
    if logged_in?
      assert_select "form[action=/news/destroy/#{news_item.id}?listing=#{listing}]" do
        assert_select "input[value=Destroy]", 1, "should have destroy button"
      end
    end
  end
  
  def assert_news_listing
    assert_select "h1", "News"
    assert_select "p a[href=/news/list/all]", "all"
    assert_select "p a[href=/news/list/current]", "current"
    assert_select "a[href=/news/new]", (logged_in? ? 1 : 0)
  end
  
  def assert_full_news_item(news_item, strongs=[])
    assert_select "div#news_item_#{news_item.id}[class=news_item]" do
      assert_select "h2", news_item.headline
      assert_select "div.content", news_item.content.gsub('*', '') do
        strongs.each do |strong|
          assert_select "strong", strong
        end
      end
    end
  end
  
end
