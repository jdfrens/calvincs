# == Schema Information
# Schema version: 20100315182611
#
# Table name: newsitems
#
#  id           :integer         not null, primary key
#  headline     :string(255)
#  content      :text
#  user_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#  expires_at   :datetime
#  teaser       :string(255)
#  goes_live_at :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Newsitem do

  fixtures :newsitems, :users

  def test_user_required
    newsitem = Newsitem.new(
            :headline => 'Valid headline',
            :teaser => 'a teaser', :content => 'Valid content.',
            :goes_live_at => 1.day.ago, :expires_at => 1.hour.ago
    )
    assert !newsitem.valid?
    assert_equal "is invalid", newsitem.errors[:user]
  end

  def test_valid_user_required
    newsitem = Newsitem.new(
            :headline => 'Valid headline',
            :teaser => 'a teaser', :content => 'Valid content.',
            :goes_live_at => 1.day.ago, :expires_at => 1.hour.ago,
            :user_id => 99
    )
    assert !newsitem.valid?
    assert_equal "is invalid", newsitem.errors[:user]
  end

  describe "finding the current news" do
    it "should include today's new" do
      Newsitem.find_current.should include(*newsitems(:todays_news, :another_todays_news))
    end

    it "should include only today's news" do
      make_past(newsitems(:todays_news))
      Newsitem.find_current.should_not include(newsitems(:todays_news))
    end

    it "should be all today's news" do
      make_current(newsitems(:past_news))
      Newsitem.find_current.should include(*newsitems(:past_news, :todays_news, :another_todays_news))

    end
  end

  def test_last_updated_dates
    assert_equal [newsitems(:todays_news).updated_at], newsitems(:todays_news).last_updated_dates
    assert_equal [newsitems(:past_news).updated_at], newsitems(:past_news).last_updated_dates
    assert_equal [newsitems(:future_news).updated_at], newsitems(:future_news).last_updated_dates
  end

  def test_find_by_year
    assert_equal(
            [ newsitems(:another_todays_news), newsitems(:todays_news) ],
            Newsitem.find_by_year(current_year)
    )
    assert_equal(
            [ newsitems(:past_news) ],
            Newsitem.find_by_year(current_year-2)
    )
    assert_equal(
            [ newsitems(:another_todays_news), newsitems(:todays_news) ],
            Newsitem.find_by_year(current_year, :today)
    )
    assert_equal(
            [ newsitems(:past_news) ],
            Newsitem.find_by_year(current_year-2, :today)
    )
    assert_equal(
            [ newsitems(:future_news), newsitems(:another_todays_news), newsitems(:todays_news) ],
            Newsitem.find_by_year(current_year, :all)
    )
  end

  describe "finding news year" do
    it "should get from the news items" do
      assert_equal((current_year-2)..current_year, Newsitem.find_news_years)
    end

    it "should be an empty range when no news items" do
      Newsitem.destroy_all
      Newsitem.find_news_years.should == (2000..1999)
    end
  end

  def test_is_current
    assert newsitems(:todays_news).is_current?
    assert newsitems(:another_todays_news).is_current?
    assert !newsitems(:past_news).is_current?
    assert !newsitems(:future_news).is_current?

    make_past(newsitems(:todays_news))
    assert !newsitems(:todays_news).is_current?

    make_current(newsitems(:another_todays_news))
    assert newsitems(:another_todays_news).is_current?, "should be no change"

    make_future(newsitems(:another_todays_news))
    assert !newsitems(:another_todays_news).is_current?

    make_current(newsitems(:future_news))
    assert newsitems(:future_news).is_current?

    make_current(newsitems(:past_news))
    assert newsitems(:past_news).is_current?
  end

  def test_formatted_expires_at
    item = Newsitem.find(:first)
    assert_not_equal '12/31/2001', item.expires_at_formatted
    assert_not_equal Time.parse('12/31/2001'), item.expires_at
    item.expires_at_formatted = '12/31/2001'
    assert_equal '12/31/2001', item.expires_at_formatted
    assert_equal Time.parse('12/31/2001'), item.expires_at
  end

  def test_formatted_goes_live_at
    item = Newsitem.find(:first)
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
    newsitems(:todays_news).goes_live_at.year
  end

  def make_past(newsitem)
    newsitem.expires_at = 2.days.ago
    newsitem.save!
  end

  def make_current(newsitem)
    newsitem.goes_live_at = 1.hour.ago
    newsitem.expires_at = 2.days.from_now
    newsitem.save!
  end

  def make_future(newsitem)
    newsitem.goes_live_at = 1.day.from_now
    newsitem.save!
  end

end
