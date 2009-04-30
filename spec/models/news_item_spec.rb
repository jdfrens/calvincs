require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class NewsItemTest < ActiveRecord::TestCase
  
  fixtures :news_items, :users

  should_require_attributes :headline, :teaser, :content, :expires_at, :goes_live_at
  should_belong_to :user
  
  def test_user_required
    news_item = NewsItem.new(
        :headline => 'Valid headline',
        :teaser => 'a teaser', :content => 'Valid content.',
        :goes_live_at => 1.day.ago, :expires_at => 1.hour.ago
        )
    assert !news_item.valid?
    assert_equal "is invalid", news_item.errors[:user]
  end
  
  def test_valid_user_required
    news_item = NewsItem.new(
        :headline => 'Valid headline',
        :teaser => 'a teaser', :content => 'Valid content.',
        :goes_live_at => 1.day.ago, :expires_at => 1.hour.ago,
        :user_id => 99
        )
    assert !news_item.valid?
    assert_equal "is invalid", news_item.errors[:user]
  end
  
  def test_find_just_current_news
    # TODO: with Rails 2.0, use new fixture method to simplify!
    assert_equal_set [news_items(:todays_news), news_items(:another_todays_news)],
      NewsItem.find_current
    
    make_past(news_items(:todays_news))
    assert_equal_set [news_items(:another_todays_news)], NewsItem.find_current
    
    make_current(news_items(:past_news))
    assert_equal_set [news_items(:past_news), news_items(:another_todays_news)],
      NewsItem.find_current
  end
  
  def test_last_updated_dates
    assert_equal [news_items(:todays_news).updated_at], news_items(:todays_news).last_updated_dates
    assert_equal [news_items(:past_news).updated_at], news_items(:past_news).last_updated_dates
    assert_equal [news_items(:future_news).updated_at], news_items(:future_news).last_updated_dates
  end
  
  def test_find_by_year
    assert_equal(
        [ news_items(:another_todays_news), news_items(:todays_news) ],
        NewsItem.find_by_year(current_year)
        )
    assert_equal(
        [ news_items(:past_news) ],
        NewsItem.find_by_year(current_year-2)
        )
    assert_equal(
        [ news_items(:another_todays_news), news_items(:todays_news) ],
        NewsItem.find_by_year(current_year, :today)
        )
    assert_equal(
        [ news_items(:past_news) ],
        NewsItem.find_by_year(current_year-2, :today)
        )
    assert_equal(
        [ news_items(:future_news), news_items(:another_todays_news), news_items(:todays_news) ],
        NewsItem.find_by_year(current_year, :all)
        )
  end
  
  def test_find_news_years
    assert_equal((current_year-2)..current_year, NewsItem.find_news_years)
  end
  
  def test_is_current
    assert  news_items(:todays_news).is_current?
    assert  news_items(:another_todays_news).is_current?
    assert !news_items(:past_news).is_current?
    assert !news_items(:future_news).is_current?
    
    make_past(news_items(:todays_news))
    assert !news_items(:todays_news).is_current?
    
    make_current(news_items(:another_todays_news))
    assert news_items(:another_todays_news).is_current?, "should be no change"
    
    make_future(news_items(:another_todays_news))
    assert !news_items(:another_todays_news).is_current?
    
    make_current(news_items(:future_news))
    assert news_items(:future_news).is_current?
    
    make_current(news_items(:past_news))
    assert news_items(:past_news).is_current?
  end
  
  def test_formatted_expires_at
    item = NewsItem.find(:first)
    assert_not_equal '12/31/2001', item.expires_at_formatted
    assert_not_equal Time.parse('12/31/2001'), item.expires_at
    item.expires_at_formatted = '12/31/2001'
    assert_equal '12/31/2001', item.expires_at_formatted
    assert_equal Time.parse('12/31/2001'), item.expires_at
  end
  
  def test_formatted_goes_live_at
    item = NewsItem.find(:first)
    assert_not_equal '1/5/1993', item.goes_live_at_formatted
    assert_not_equal Time.parse('01/05/1993'), item.goes_live_at
    item.goes_live_at_formatted = '1/5/1993'
    assert_equal '01/05/1993', item.goes_live_at_formatted
    assert_equal Time.parse('01/05/1993'), item.goes_live_at
  end
  
  #
  # Helpers
  #
  private

  def current_year
    news_items(:todays_news).goes_live_at.year
  end
    
  def make_past(news_item)
    news_item.expires_at = 2.days.ago
    news_item.save!
  end
  
  def make_current(news_item)
    news_item.goes_live_at = 1.hour.ago
    news_item.expires_at = 2.days.from_now
    news_item.save!
  end
  
  def make_future(news_item)
    news_item.goes_live_at = 1.day.from_now
    news_item.save!
  end
  
end
