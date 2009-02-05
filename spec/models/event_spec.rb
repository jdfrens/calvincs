require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class EventTest < Test::Unit::TestCase
  fixtures :events
  
  should_require_attributes :title
  should_require_attributes :descriptor
  should_require_attributes :start
  should_require_attributes :stop
   
  context "testing the system" do
    should "have single-table inheritance" do
      assert_equal Colloquium, events(:old_colloquium).class
      assert_equal(Conference, events(:old_conference).class)
    end
  end
  
  context "the length of an event" do
    should "be in hours for a colloquium" do
      assert_equal 1, events(:old_colloquium).length
      assert_equal 2, events(:todays_colloquium).length
    end
    
    should "be in days for a conference" do
      assert_equal 3, events(:old_conference).length
      assert_equal 1, events(:next_weeks_conference).length
    end
  end

  context "seeing if events can really be found by dates" do
    should "have a default return for finding within a range" do
      assert_equal [], Event.find_within(Time.now, 1.minute.from_now)
    end

    should "find within a range based on all possible overlappings" do
      event = events(:todays_colloquium)
      assert_equal [], Event.find_within(event.stop + 2.hours, event.stop + 3.hours)
      assert_equal [], Event.find_within(event.start - 3.hours, event.start - 2.hours)
      assert_equal [event], Event.find_within(event.start + 1.minute, event.stop + 1.minute)
      assert_equal [event], Event.find_within(event.start - 1.minute, event.stop + 1.minute)
      assert_equal [event], Event.find_within(event.start + 1.minute, event.stop - 1.minute)
      assert_equal [event], Event.find_within(event.start - 1.minute, event.stop - 1.minute)
    end
    
    should "find more than one event with a given range" do
      assert_equal [events(:todays_colloquium), events(:within_a_week_colloquium), events(:within_a_month_colloquium), events(:next_weeks_conference)],
        Event.find_within(Time.now, 2.months.from_now)
    end
  end

  context "mocked tests for higher-level find-by-date methods" do
    should "find today's events" do
      today = Time.local(2007, 11, 13, 13, 30, 58)
      start = Time.local(2007, 11, 13,  0,  0)
      stop  = Time.local(2007, 11, 13, 23, 59)
      Event.expects(:find_within).with(start, stop).returns(:all_of_todays_events)
      assert_same(:all_of_todays_events, Event.find_by_today(today))
    end

    should "find within a whole week" do
      sunday =    Time.local(2007, 11,  4, 13)
      monday =    Time.local(2007, 11,  5, 13)
      tuesday =   Time.local(2007, 11,  6, 13)
      wednesday = Time.local(2007, 11,  7, 13)
      thursday =  Time.local(2007, 11,  8, 13)
      friday =    Time.local(2007, 11,  9, 13)
      saturday =  Time.local(2007, 11, 10, 13)

      [sunday, monday, tuesday, wednesday, thursday, friday, saturday].each do |day|
        Event.expects(:find_within).with(sunday, saturday).returns(:the_events)
        assert_same(:the_events, Event.find_by_week_of(day))
      end
    end

    should "find til end of week" do
      sunday =    Time.local(2007, 11,  4, 13)
      monday =    Time.local(2007, 11,  5, 13)
      tuesday =   Time.local(2007, 11,  6, 13)
      wednesday = Time.local(2007, 11,  7, 13)
      thursday =  Time.local(2007, 11,  8, 13)
      friday =    Time.local(2007, 11,  9, 13)
      saturday =  Time.local(2007, 11, 10, 13)

      [sunday, monday, tuesday, wednesday, thursday, friday, saturday].each do |day|
        Event.expects(:find_within).with(day, saturday).returns(:the_events)
        assert_same(:the_events, Event.find_by_week_of(day, :sunday => false))
      end
    end

    should "find in fall semester" do
      fall    = Time.local(2007, 11, 12, 13)
      Event.expects(:find_within).with(Time.local(2007, 8,  1), Time.local(2007, 12, 31)).returns(:fall_events)
      assert_same(:fall_events, Event.find_by_semester_of(fall))
    end

    should "find in interim (actually spring semester)" do
      interim = Time.local(2007,  1,  8, 13)
      Event.expects(:find_within).with(Time.local(2007, 1,  1), Time.local(2007,  7, 31)).returns(:interim_events)
      assert_same(:interim_events, Event.find_by_semester_of(interim))
    end

    should "find in spring semester" do
      spring  = Time.local(2007,  3,  7, 13)
      Event.expects(:find_within).with(Time.local(2007, 1,  1), Time.local(2007,  7, 31)).returns(:spring_events)
      assert_same(:spring_events, Event.find_by_semester_of(spring))
    end
  end
  
end
