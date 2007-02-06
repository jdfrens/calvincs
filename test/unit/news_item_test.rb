require File.dirname(__FILE__) + '/../test_helper'

class NewsItemTest < Test::Unit::TestCase
  fixtures :news_items, :users

  should "have creators" do
    assert_equal User.find(1), NewsItem.find(5).user
    assert_equal User.find(2), NewsItem.find(8).user
  end
  
end
