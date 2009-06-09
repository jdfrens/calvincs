require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Event do
  
  fixtures :events
  
  should_require_attributes :title
  should_require_attributes :descriptor
  should_require_attributes :start
  should_require_attributes :stop

  context "creating instances of the subclasses" do
    it "should create a colloquium" do
      params = { :kind => "colloquium", :foo => mock("foo param") }
      colloquium = mock("colloquium")

      Colloquium.should_receive(:new).with(params).and_return(colloquium)

      Event.new_event(params).should eql(colloquium)
    end

    it "should create a conference" do
      params = { :kind => "conference", :foo => mock("foo param") }
      conference = mock("conference")

      Conference.should_receive(:new).with(params).and_return(conference)

      Event.new_event(params).should eql(conference)
    end
  end

  it "should compute range of years of events" do
    Event.should_receive(:first_year).and_return(1492)
    Event.should_receive(:last_year).and_return(1518)
    
    Event.years_of_events.should == (1492..1518)
  end

  it "should find the first year" do
    event = Event.first
    event.start = Time.parse("February 15, 1970")
    event.save!

    Event.first_year.should == 1970
  end

  it "should find the last year" do
    event = Event.first
    event.stop = Time.parse("February 15, 2032")
    event.save!

    Event.last_year.should == 2032
  end

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

  describe "setting the length of an event" do
    it "should be in hours for a colloquium" do
      colloquium = events(:todays_colloquium)
      colloquium.length = 5
      colloquium.save!
      colloquium.stop.should == (colloquium.start + 5.hours)
    end

    it "should be in days for a conference" do
      conference = events(:next_weeks_conference)
      conference.length = 5
      conference.save!
      conference.stop.should == (conference.start + 5.days)
    end
  end

  describe "the timing of an event" do
    it "should use just the start datetime of a colloquium" do
      start = mock("start time")
      event = Colloquium.new(:title => "foobar", :start => start)

      start.should_receive(:to_s).with(:colloquium).and_return("the full time")
      
      event.timing.should == "the full time"
    end

    it "should use the start date and ending date" do
      start = mock("start time")
      stop = mock("stop time")
      event = Conference.new(:title => "foobar", :start => start, :stop => stop)

      start.should_receive(:to_s).with(:conference).and_return("START")
      stop.should_receive(:to_s).with(:conference).and_return("STOP")

      event.timing.should == "START thru STOP"
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

  describe "setting the length" do
    before(:each) do
      @event = Colloquium.create!(:title => "Something", :start => 1.hour.from_now, :stop => 2.hours.from_now, :descriptor => "colloquium")
    end

    it "should establish original length" do
      @event.length.should be_close(1.0, 0.001)
    end

    it "should have new length" do
      @event.length = 2
      @event.save!
      @event.length.should be_close(2.0, 0.001)
    end

    it "should adjust stop time" do
      @event.length = 2
      @event.save!
      @event.stop.should == (@event.start + 2.hours)
    end

    it "should work for a string argument" do
      @event.length = "2"
      @event.save!
      @event.stop.should == (@event.start + 2.hours)
    end

  end
  
end
