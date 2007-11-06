require File.dirname(__FILE__) + '/../test_helper'

class EventTest < Test::Unit::TestCase
  fixtures :events

  # Event#find_by_week_of(date=Time.now)
  # Event#find_by_month_of(date=Time.now)
  # Event#find_by_semester_of(date=Time.now)
  # all can be implemented in terms of:
  # Event#find_within(start, stop)
  
  def test_inheritance
    assert_equal Colloquium, events(:old_colloquium).class
    assert_equal(Conference, events(:old_conference).class)
  end

  def test_find_within
    assert_equal [], Event.find_within(Time.now, 1.minute.from_now)
    
    event = events(:todays_colloquium)
    assert_equal [], Event.find_within(event.stop + 2.hours, event.stop + 3.hours)
    assert_equal [], Event.find_within(event.start - 3.hours, event.start - 2.hours)
    assert_equal [event], Event.find_within(event.start + 1.minute, event.stop + 1.minute)
    assert_equal [event], Event.find_within(event.start - 1.minute, event.stop + 1.minute)
    assert_equal [event], Event.find_within(event.start + 1.minute, event.stop - 1.minute)
    assert_equal [event], Event.find_within(event.start - 1.minute, event.stop - 1.minute)
    
    assert_equal [events(:todays_colloquium), events(:within_a_week_colloquium), events(:within_a_month_colloquium)],
      Event.find_within(Time.now, 2.months.from_now)
  end
end
