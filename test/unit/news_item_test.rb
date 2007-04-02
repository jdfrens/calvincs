require File.dirname(__FILE__) + '/../test_helper'

class NewsItemTest < Test::Unit::TestCase
  
  fixtures :news_items, :users

  should "have connection to creators" do
    assert_equal User.find(1), news_items(:todays_news).user
    assert_equal User.find(2), news_items(:another_todays_news).user
  end
  
  should "not create news item without title" do
    news_item = NewsItem.new(
        :title => '',
        :brief_description => 'description', :content => 'Valid content.',
        :expires_at => 1.hour.ago, :user_id => 1
    )
    assert !news_item.valid?
    assert_equal "can't be blank", news_item.errors[:title]
  end
  
  should "not create news item without description" do
    news_item = NewsItem.new(
        :title => 'Valid title',
        :brief_description => '', :content => 'Valid content.',
        :expires_at => 1.hour.ago, :user_id => 1
    )
    assert !news_item.valid?
    assert_equal "can't be blank", news_item.errors[:brief_description]
  end
    
  should "not create news item without content" do
    news_item = NewsItem.new(
        :title => 'Valid title',
        :brief_description => 'description', :content => '', :expires_at => 1.hour.ago,
        :user_id => 1
    )
    assert !news_item.valid?
    assert_equal "can't be blank", news_item.errors[:content]
  end
    
  should "not create news item without expires-at date" do
    news_item = NewsItem.new(
        :title => 'Valid title',
        :brief_description => 'description', :content => 'Valid content.',
        :user_id => 1
    )
    assert !news_item.valid?
    assert_equal "can't be blank", news_item.errors[:expires_at]
  end

  should "not create news item without user" do
    news_item = NewsItem.new(
        :title => 'Valid title',
        :brief_description => 'description', :content => 'Valid content.',
        :expires_at => 1.hour.ago
    )
    assert !news_item.valid?
    assert_equal "is invalid", news_item.errors[:user]
  end
    
  should "not create news item with invalid user" do
    news_item = NewsItem.new(
        :title => 'Valid title',
        :brief_description => 'description', :content => 'Valid content.',
        :expires_at => 1.hour.ago, :user_id => 99
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
    news_items = NewsItem.find_filtered_news("all")
    assert_equal 3, news_items.size
    assert news_items.include?(news_items(:todays_news))
    assert news_items.include?(news_items(:another_todays_news))
    assert news_items.include?(news_items(:past_news))  
  end
  
  should "find current through filter" do
    news_items = NewsItem.find_filtered_news("current")
    assert_equal 2, news_items.size
    assert news_items.include?(news_items(:todays_news))
    assert news_items.include?(news_items(:another_todays_news))
  end
  
  should "know if current" do
    assert news_items(:todays_news).is_current?
    assert news_items(:another_todays_news).is_current?
    assert !news_items(:past_news).is_current?
    
    make_past(news_items(:todays_news))
    make_current(news_items(:another_todays_news))
    make_current(news_items(:past_news))
    assert !news_items(:todays_news).is_current?
    assert news_items(:another_todays_news).is_current?
    assert news_items(:past_news).is_current?
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
    news_item.expires_at = 2.days.from_now
    news_item.save!
  end
  
end
