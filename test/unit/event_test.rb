require File.dirname(__FILE__) + '/../test_helper'

class EventTest < Test::Unit::TestCase
  fixtures :events

  # these methods should probably be located elsewhere (but where?)
  # they should return a range of Times to be used with Event#within
  # Event#this_week
  # Event#next_week
  # Event#this_month
  # Event#this_semester
  # Event#this_year (school year!)
  
  def test_inheritance
    assert_equal Colloquium, events(:old_colloquium).class
    assert_equal(Conference, events(:old_conference).class)
  end
  
  def test_within
    assert events(:old_colloquium).within(3.days.ago..Time.now)
    assert events(:old_colloquium).within((2.days.ago-1.minute)..Time.now)
    assert events(:old_colloquium).within(3.days.ago..(2.days.ago+1.minute))

    assert ! events(:old_colloquium).within(1.days.ago..Time.now)
    assert ! events(:old_colloquium).within(Time.now..2.weeks.from_now)
    assert ! events(:old_colloquium).within((2.days.ago+61.minutes)..Time.now)
    assert ! events(:old_colloquium).within(3.days.ago..(2.days.ago-1.minute))    
  end
  
  def test_stop
    assert_equal(events(:old_colloquium).start + 1.hour, events(:old_colloquium).stop)
    assert_equal(events(:old_conference).start + 3.days, events(:old_conference).stop)
  end
end
