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
  
  context "index action" do
    should "show listing and news items" do
      get :index
    
      assert_response :success
      assert_standard_layout :title => "News", :menu => :news,
        :last_updated => news_items(:another_todays_news).updated_at
      assert_select "h1#top", "Current News"
    
      assert_select "#news-listing ul" do
        assert_select "li", 3
        assert_select "li:nth-child(1) a[href=/news#news-item-5]", "News of Today II"
        assert_select "li:nth-child(2) a[href=/news#news-item-3]", "News of Today"
        assert_select "li.other:nth-child(3) a[href=/news/list]", "News Archive..."
      end
    
      assert_full_news_item news_items(:another_todays_news)
      assert_full_news_item news_items(:todays_news)
    end
    
    # TODO: should "redirect to list if no current news items?"
  end
  
  context "new action" do
    should_redirect_to_login_when_NOT_logged_in :new
    
    context "when logged in" do
      should "create new news item" do
        get :new, {}, user_session(:edit)
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
    end
  end
  
  context "save action" do
    should "redirect when NOT logged in" do
      post :save, :news_item => {
        :headline => 'News Headline', :content => 'News Content',
        :expires_at => [2007, 12, 31]
      }
      assert_redirected_to_login
    end
  
    should "save" do
      post :save, { :news_item => {
          :headline => 'News Headline',
          :teaser => 'Brief Description', :content => 'News Content',
          'goes_live_at(1i)' => '2007', 'goes_live_at(2i)' => '11',
          'goes_live_at(3i)' => '15',
          'expires_at(1i)' => '2007', 'expires_at(2i)' => '12',
          'expires_at(3i)' => '31',
        }}, user_session(:edit)
      assert_redirected_to :controller => 'news', :action => 'list'
    
      news_item = NewsItem.find_by_headline('News Headline')
      assert_not_nil news_item
      assert_equal 'News Headline', news_item.headline
      assert_equal 'News Content', news_item.content
      assert_equal Time.local(2007, 11, 15), news_item.goes_live_at
      assert_equal Time.local(2007, 12, 31), news_item.expires_at
    end
  
    should "fail when given bad data" do
      post :save, { :news_item => {
          :headline => '', :content => ''
        }}, user_session(:edit)
      
      assert_response :success
      assert !flash.empty?
      assert_equal 'Invalid values for the news item', flash[:error]
      assert_equal 4, NewsItem.count, "should have only four news items still"
    end
  end
  
  context "list action" do
    should "list years with actual news" do
      get :list
      
      assert_response :success
      assert_standard_layout :title => "News Archive"

      assert_equal((current_year-2..current_year), assigns(:years))
      
      assert_select "h1", "News Archive"
      assert_select "ul#news-years" do
        assert_select "li", 3
        assert_select "li a[href=/news/list/#{current_year}]",
          "News of #{current_year}"
        assert_select "li a[href=/news/list/#{current_year-1}]",
          "News of #{current_year - 1}"
        assert_select "li a[href=/news/list/#{current_year-2}]",
          "News of #{current_year - 2}"
      end
    end
  
    should "list by this year" do
      get :list, { :id => current_year }
    
      assert_response :success
      assert_standard_layout :title => "News of #{current_year}",
        :last_updated => news_items(:another_todays_news).updated_at
      assert_news_listing(current_year)
      assert_select "div#news-listing table[summary=news items]" do
        assert_select "tr", 2*2
        assert_news_item_entry 1, news_items(:another_todays_news), "current"
        assert_news_item_entry 2, news_items(:todays_news), "current"
      end
      assert_select "a[href=/news/list]", "News Archive..."
    end
  
    should "list by last year" do
      get :list, { :id => current_year - 1 }
    
      assert_response :success
      assert_standard_layout :title => "News of #{current_year - 1}"
      assert_news_listing(current_year-1)
      assert_select "div#news-listing table[summary=news items]" do
        assert_select "tr", 0
      end
      assert_select "a[href=/news/list]", "News Archive..."
    end
  
    should "list by year in past" do
      get :list, { :id => current_year - 2 }
    
      assert_response :success
      assert_standard_layout :title => "News of #{current_year - 2}",
        :last_updated => news_items(:past_news).updated_at
      assert_news_listing(current_year-2)
      assert_select "div#news-listing table[summary=news items]" do
        assert_select "tr", 1*2
        assert_news_item_entry 1, news_items(:past_news), "all"
      end
      assert_select "a[href=/news/list]", "News Archive..."
    end  
  
    context "when logged in" do
      should "list this year" do
        get :list, { :id => current_year }, user_session(:edit)

        assert_response :success
        assert_standard_layout :title => "News of #{current_year}",
          :last_updated => news_items(:future_news).updated_at
        assert_news_listing(current_year)
        assert_select "div#news-listing table[summary=news items]" do
          assert_select "tr", 3*2, "should have two current and one in the future (this year)"
          assert_news_item_entry 1, news_items(:future_news), current_year
          assert_news_item_entry 2, news_items(:another_todays_news), current_year
          assert_news_item_entry 3, news_items(:todays_news), current_year
        end
      end
    end
  end
  
  context "view action" do
    context "when NOT logged in" do
      should "view news item" do
        item = news_items(:todays_news)
    
        get :view, { :id => item.id }
    
        assert_response :success
        assert_standard_layout :title => item.headline,
          :last_updated => item.updated_at
        assert_select "h1", item.headline
        assert_select "div#news-item-content .textilized", "Something happened today."
        
        # no admin stuff
        assert_select "form[action=/news/update_news_content/3]", false
        assert_select "p#expires_at", false
      end
    end
  
    context "when logged in" do
      should "view a news item" do
        item = news_items(:todays_news)
        id = item.id
    
        get :view, { :id => id }, user_session(:edit)
    
        assert_response :success
        assert_standard_layout :title => item.headline,
          :last_updated => news_items(:todays_news).updated_at
    
        assert_select "h1 span#news_item_headline_#{id}_in_place_editor", item.headline
        assert_select "div#content h1 input#edit_headline", true
    
        assert_select "div#news-item-teaser span#news_item_teaser_#{id}_in_place_editor", item.teaser
        assert_select "div#news-item-teaser input#edit_teaser", true

        assert_select "div#news-item-content .textilized", "Something happened today."
        
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
    end
  end
  
  context "setting headline of news item" do
    context "when logged in" do
      should "set the headline" do
        xhr :post, :set_news_item_headline,
          { :id => news_items(:todays_news).id, :value => 'New Headline' },
          user_session(:edit)
        assert_response :success
        assert_equal "New Headline", @response.body
    
        assert_equal 'New Headline', NewsItem.find(news_items(:todays_news).id).headline
      end
    end
  
    context "when NOT logged in" do
      should "redirect" do
        xhr :get, :set_news_item_headline, :id => news_items(:todays_news).id, :value => 'New HeadLine'
        assert_redirected_to_login
        assert_equal "News of Today", news_items(:todays_news).headline,
          'headline remains unchanged'
      end
    end
  end
  
  context "setting teaser of news item" do
    context "when logged in" do
      should "set the teaser" do
        xhr :get, :set_news_item_teaser,
          { :id => news_items(:todays_news).id, :value => 'Teaser of Newness' },
          user_session(:edit)
      
        assert_response :success
        assert_equal "Teaser of Newness", @response.body
    
        assert_equal 'Teaser of Newness', NewsItem.find(news_items(:todays_news).id).teaser
      end
    end
  
    context "when NOT logged in" do
      should "redirect" do
        xhr :get, :set_news_item_teaser, :id => news_items(:todays_news).id, :value => 'Teaser Teaser'
    
        assert_redirected_to_login
        assert_equal "Some *teaser*.", news_items(:todays_news).teaser,
          'teaser remains unchanged'
      end
    end
  end
  
  context "updating content of news item" do
    context "when logged in" do
      should "update content" do
        item = news_items(:todays_news)
        xhr :get, :update_news_item_content,
          { :id => item.id, :news_item => { :content => 'News that is fit to print.' } },
          user_session(:edit)
        
        assert_response :success
        assert_select_rjs :replace_html, "news-item-content" do
          assert_select ".textilized", "News that is fit to print."
        end
    
        item.reload
        assert_equal 'News that is fit to print.', item.content
      end
    end
  
    context "when NOT logged in" do
      should "redirect" do
        item = news_items(:todays_news)
        original_content = item.content
        xhr :get, :update_news_item_content,
          { :id => item.id, :news_item => { :content => 'foobar!' } }
        
        assert_redirected_to_login
        item.reload
        assert_equal original_content, item.content
      end
    end
  end
    
  context "set goes live date of news item" do
    context "when logged in" do
      should "set goes live date" do
        item = news_items(:todays_news)
        xhr :get, :set_news_item_goes_live_at_formatted,
          { :id => item.id, :value => '01/05/2007' }, user_session(:edit)
        
        assert_response :success
        assert_equal '01/05/2007', @response.body
        item.reload
        assert_equal '01/05/2007', item.goes_live_at_formatted
      end
    end
  
    context "when NOT logged in" do
      should "redirect" do
        item = news_items(:todays_news)
        original_date = item.goes_live_at
        xhr :get, :set_news_item_goes_live_at_formatted,
          { :id => news_items(:todays_news).id, :value => '01/05/2007' }
        assert_redirected_to_login
        item.reload
        assert_equal original_date, item.goes_live_at, 'goes-live remains unchanged'
      end
    end
  end
  
  context "set expired at date of news item" do
    context "when logged in" do
      should "set expired at date" do
        item = news_items(:todays_news)
        xhr :get, :set_news_item_expires_at_formatted,
          { :id => item.id, :value => '01/05/2007' }, user_session(:edit)
        assert_response :success
        assert_equal '01/05/2007', @response.body
        item.reload
        assert_equal '01/05/2007', item.expires_at_formatted
      end
    end
  
    context "when NOT logged in" do
      should "redirect" do
        item = news_items(:todays_news)
        original_date = item.expires_at
        xhr :get, :set_news_item_expires_at_formatted,
          { :id => item.id, :value => '01/05/2007' }
        assert_redirected_to_login
        item.reload
        assert_equal original_date, item.expires_at, 'expires-at remains unchanged'
      end
    end
  end
  
  context "destroy action" do
    context "when NOT logged in" do
      should "redirect" do
        post :destroy, { :id => news_items(:todays_news).id }
        assert_redirected_to_login
        assert_equal 4, NewsItem.count, "should still have four news items"
      end
    end
  
    context "when logged in" do
      should "destroy" do
        assert_not_nil NewsItem.find_by_headline("News of Today"), "sanity check"
        assert_equal 4, NewsItem.count
    
        post :destroy, { :id => news_items(:todays_news).id, :listing => 'foobar' },
          user_session(:edit)
    
        assert_redirected_to :controller => 'news', :action => 'list', :id => 'foobar'
        assert_equal 3, NewsItem.count, "lost just one news item"
        assert_nil NewsItem.find_by_headline("News of Today")
      end
    end
  end
  
  #
  # Helpers
  #
  private
  
  def current_year
    news_items(:todays_news).goes_live_at.year
  end
  
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
  
  def assert_news_item_entry(n, news_item, listing)
    time_class = news_item.is_current? ? "current-news" : "past-news"
    assert_select "tr[class=#{time_class}]:nth-child(#{n*2-1})" do
      assert_select "td a[href=/news/view/#{news_item.id}]", news_item.headline
    end
    assert_select "tr[class=#{time_class}]:nth-child(#{n*2})" do
      assert_select "td.goes-live-date", "posted on #{news_item.goes_live_at.to_s(:news_posted)}"
    end
    if logged_in?
      assert_select "form[action=/news/destroy/#{news_item.id}?listing=#{listing}]" do
        assert_select "input[value=Destroy]", 1, "should have destroy button"
      end
    end
  end
  
  def assert_news_listing(year)
    assert_select "h1", "News of #{year}"
    assert_select "a[href=/news/new]", (logged_in? ? 1 : 0)
  end
  
  def assert_full_news_item(news_item)
    assert_select "div#news-item-#{news_item.id}[class=news-item]" do
      assert_select "h2", news_item.headline
      assert_select "p.goes-live-date", "Posted on #{news_item.goes_live_at.to_s(:news_posted)}"
      assert_select "div.content .textilized", news_item.content
      assert_select "p.more a[href=#top]", "back to top..."
    end
  end
  
end
