require File.dirname(__FILE__) + '/../test_helper'

class NewsItemTest < Test::Unit::TestCase
  
  fixtures :news_items, :users
  
  def test_have_connection_to_creators
    assert_equal User.find(1), news_items(:todays_news).user
    assert_equal User.find(2), news_items(:another_todays_news).user
  end
  
  def test_headline_required
    news_item = NewsItem.new(
        :headline => '',
        :teaser => 'a teaser', :content => 'Valid content.',
        :goes_live_at => 1.day.ago, :expires_at => 1.hour.ago, 
        :user_id => 1
        )
    assert !news_item.valid?
    assert_equal "can't be blank", news_item.errors[:headline]
  end
  
  def test_teaser_required
    news_item = NewsItem.new(
        :headline => 'Valid headline',
        :teaser => '', :content => 'Valid content.',
        :goes_live_at => 1.day.ago, :expires_at => 1.hour.ago,
        :user_id => 1
        )
    assert !news_item.valid?
    assert_equal "can't be blank", news_item.errors[:teaser]
  end
  
  def test_content_required
    news_item = NewsItem.new(
        :headline => 'Valid headline',
        :teaser => 'a teaser', :content => '',
        :goes_live_at => 1.day.ago, :expires_at => 1.hour.ago,
        :user_id => 1
        )
    assert !news_item.valid?
    assert_equal "can't be blank", news_item.errors[:content]
  end
  
  def test_expires_at_required
    news_item = NewsItem.new(
        :headline => 'Valid headline',
        :teaser => 'a teaser', :content => 'Valid content.',
        :goes_live_at => 1.day.ago,
        :user_id => 1
        )
    assert !news_item.valid?
    assert_equal "can't be blank", news_item.errors[:expires_at]
  end
  
  def test_goes_live_at_required
    news_item = NewsItem.new(
        :headline => 'Valid headline',
        :teaser => 'a teaser', :content => 'Valid content.',
        :expires_at => 1.hour.ago,
        :user_id => 1
        )
    assert !news_item.valid?
    assert_equal "can't be blank", news_item.errors[:goes_live_at]
  end
  
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
    assert_equal_set [news_items(:todays_news), news_items(:another_todays_news)],
      NewsItem.find_current
    
    make_past(news_items(:todays_news))
    assert_equal_set [news_items(:another_todays_news)], NewsItem.find_current
    
    make_current(news_items(:past_news))
    assert_equal_set [news_items(:past_news), news_items(:another_todays_news)],
      NewsItem.find_current
  end
  
  def test_find_filtered_all
    assert_equal_set(
        [ news_items(:todays_news), news_items(:another_todays_news),
          news_items(:past_news), news_items(:future_news) ],
        NewsItem.find_filtered_news('all')
        )
  end
  
  def test_find_filtered_current
    assert_equal_set(
        [ news_items(:todays_news), news_items(:another_todays_news) ],
        NewsItem.find_filtered_news('current')
        )
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
  
  def test_rendered_content
    assert_equal "Something happened *today*.",
        news_items(:todays_news).content
    assert_equal "<p>Something happened <strong>today</strong>.</p>",
        news_items(:todays_news).render_content
    assert_equal "<p>Something else happened today.</p>",
        news_items(:another_todays_news).render_content
    assert_equal "<p>Something happened in the distant <em>past</em>.</p>",
        news_items(:past_news).render_content
  end
  
  def test_rendered_teaser
    assert_equal "Some *teaser*.", news_items(:todays_news).teaser
    assert_equal "Some <strong>teaser</strong>.", news_items(:todays_news).render_teaser
  end
  
  #
  # Helpers
  #
  private
  
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
