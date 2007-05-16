require File.dirname(__FILE__) + '/../test_helper'

class NewsItemTest < Test::Unit::TestCase
  
  fixtures :news_items, :users
  
  should "have connection to creators" do
    assert_equal User.find(1), news_items(:todays_news).user
    assert_equal User.find(2), news_items(:another_todays_news).user
  end
  
  should "not create news item without headline" do
    news_item = NewsItem.new(
                             :headline => '',
    :teaser => 'a teaser', :content => 'Valid content.',
    :goes_live_at => 1.day.ago, :expires_at => 1.hour.ago, 
    :user_id => 1
    )
    assert !news_item.valid?
    assert_equal "can't be blank", news_item.errors[:headline]
  end
  
  should "not create news item without a teaser" do
    news_item = NewsItem.new(
                             :headline => 'Valid headline',
    :teaser => '', :content => 'Valid content.',
    :goes_live_at => 1.day.ago, :expires_at => 1.hour.ago,
    :user_id => 1
    )
    assert !news_item.valid?
    assert_equal "can't be blank", news_item.errors[:teaser]
  end
  
  should "not create news item without content" do
    news_item = NewsItem.new(
                             :headline => 'Valid headline',
    :teaser => 'a teaser', :content => '',
    :goes_live_at => 1.day.ago, :expires_at => 1.hour.ago,
    :user_id => 1
    )
    assert !news_item.valid?
    assert_equal "can't be blank", news_item.errors[:content]
  end
  
  should "not create news item without expires-at date" do
    news_item = NewsItem.new(
                             :headline => 'Valid headline',
    :teaser => 'a teaser', :content => 'Valid content.',
    :goes_live_at => 1.day.ago,
    :user_id => 1
    )
    assert !news_item.valid?
    assert_equal "can't be blank", news_item.errors[:expires_at]
  end
  
  should "not create news item without goes-live date" do
    news_item = NewsItem.new(
                             :headline => 'Valid headline',
    :teaser => 'a teaser', :content => 'Valid content.',
    :expires_at => 1.hour.ago,
    :user_id => 1
    )
    assert !news_item.valid?
    assert_equal "can't be blank", news_item.errors[:goes_live_at]
  end
  
  should "not create news item without user" do
    news_item = NewsItem.new(
                             :headline => 'Valid headline',
    :teaser => 'a teaser', :content => 'Valid content.',
    :goes_live_at => 1.day.ago, :expires_at => 1.hour.ago
    )
    assert !news_item.valid?
    assert_equal "is invalid", news_item.errors[:user]
  end
  
  should "not create news item with invalid user" do
    news_item = NewsItem.new(
                             :headline => 'Valid headline',
    :teaser => 'a teaser', :content => 'Valid content.',
    :goes_live_at => 1.day.ago, :expires_at => 1.hour.ago,
    :user_id => 99
    )
    assert !news_item.valid?
    assert_equal "is invalid", news_item.errors[:user]
  end
  
  should "find just current news" do
    news_items = NewsItem.find_current
    assert_equal 2, news_items.size
    assert news_items.include?(news_items(:todays_news))
    assert news_items.include?(news_items(:another_todays_news))
    
    make_past(news_items(:todays_news))
    news_items = NewsItem.find_current
    assert_equal 1, news_items.size
    assert news_items.include?(news_items(:another_todays_news))
    
    make_current(news_items(:past_news))
    news_items = NewsItem.find_current
    assert_equal 2, news_items.size
    assert news_items.include?(news_items(:another_todays_news))
    assert news_items.include?(news_items(:past_news))
  end
  
  should "find all through filter" do
    found_items = NewsItem.find_filtered_news('all')
    assert_equal 4, found_items.size
    assert found_items.include?(news_items(:todays_news))
    assert found_items.include?(news_items(:another_todays_news))
    assert found_items.include?(news_items(:past_news))
    assert found_items.include?(news_items(:future_news))
  end
  
  should "find current through filter" do
    found_items = NewsItem.find_filtered_news("current")
    assert_equal 2, found_items.size
    assert found_items.include?(news_items(:todays_news))
    assert found_items.include?(news_items(:another_todays_news))
  end
  
  should "know if current" do
    assert news_items(:todays_news).is_current?
    assert news_items(:another_todays_news).is_current?
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
  
  should "render textile using RedCloth" do
    assert_equal "Something happened <strong>today</strong>.",
    news_items(:todays_news).render_content
    assert_equal "Something else happened today.",
    news_items(:another_todays_news).render_content
    assert_equal "Something happened in the distant <em>past</em>.",
    news_items(:past_news).render_content
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
