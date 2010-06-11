require 'spec_helper'

describe "/home/feed.atom.builder" do

  before do
    @newsitems = []
    @todays_events = []
    @weeks_events = []
    assigns[:newsitems] = @newsitems
    assigns[:todays_events] = @todays_events
    assigns[:weeks_events] = @weeks_events
  end

  it "should have a title" do
    assigns[:updated_at] = Time.parse("March 7, 1970")

    render "/home/feed.atom"

    response.should have_selector("feed") do |feed|
      feed.should have_selector("title",
                                :content => "Calvin College Computer Science - News and Events")
      feed.should have_selector("updated", :content => "1970-03-07")
    end
  end

  it "should render a news item" do
    @newsitems = [mock_model(Newsitem, :headline => "The Headline", :content => "The Body",
                             :goes_live_at => Time.parse("March 7, 1970"),
                             :updated_at => Time.now)]
    assigns[:newsitems] = @newsitems

    render "/home/feed.atom"

    response.should have_selector("entry") do |entry|
      entry.should have_selector("title", :content => "The Headline")
      entry.should have_selector("published", :content => "1970-03-07")
      entry.should have_selector("updated")
      entry.should have_selector("content", :content => "The Body", :type => "html")
      entry.should have_selector("author") do |author|
        author.should have_selector("name", :content => "Computing@Calvin")
      end
    end
  end

  it "should render multiple news items" do
    @newsitems = [mock_model(Newsitem, :headline => "Headline 1", :content => "content",
                             :goes_live_at => Time.now),
                  mock_model(Newsitem, :headline => "Headline 2", :content => "content",
                             :goes_live_at => Time.now),
                  mock_model(Newsitem, :headline => "Headline 3", :content => "content",
                             :goes_live_at => Time.now)]
    assigns[:newsitems] = @newsitems

    render "/home/feed.atom"

    response.should have_selector("entry") do |entry|
      entry.should have_selector("title", :content => "Headline 1")
    end
    response.should have_selector("entry") do |entry|
      entry.should have_selector("title", :content => "Headline 2")
    end
    response.should have_selector("entry") do |entry|
      entry.should have_selector("title", :content => "Headline 3")
    end
  end

  it "should render an event for today" do
    @todays_events = [mock_model(Event, :full_title => "Full Event Title",
                                 :description => "Go to this event!", :updated_at => Time.now)]
    assigns[:todays_events] = @todays_events

    render "/home/feed.atom"

    response.should have_selector("entry") do |entry|
      entry.should have_selector("title", :content => "Full Event Title", :type => "html")
      entry.should have_selector("published", :content => Date.today.to_s)
      entry.should have_selector("updated")
      entry.should have_selector("content", :content => "Go to this event!", :type => "html")
      entry.should have_selector("author") do |author|
        author.should have_selector("name", :content => "Computing@Calvin")
      end
    end
  end

  it "should render an event for today with a special id" do
    @todays_events = [mock_model(Event, :full_title => "Full Event Title", :description => "Go to this event!")]
    assigns[:todays_events] = @todays_events

    render "/home/feed.atom"

    response.should have_selector("entry id", :content => "tag:test.host,2005:TodaysEvent/#{@todays_events[0].id}")
  end

  it "should render multiple events for today" do
    @todays_events = [mock_model(Event, :full_title => "Today #1", :description => "#1"),
                      mock_model(Event, :full_title => "Today #2", :description => "#2"),
                      mock_model(Event, :full_title => "Today #3", :description => "#3")]
    assigns[:todays_events] = @todays_events

    render "/home/feed.atom"

    response.should have_selector("entry") do |entry|
      entry.should have_selector("title", :content => "Today #1", :type => "html")
      entry.should have_selector("title", :content => "Today #2", :type => "html")
      entry.should have_selector("title", :content => "Today #3", :type => "html")
    end
  end

  it "should render an event for this week with a special id" do
    @weeks_events = [mock_model(Event, :full_title => "Next Week Is Now", :description => "Time travel!")]
    assigns[:weeks_events] = @weeks_events

    render "/home/feed.atom"

    response.should have_selector("entry id", :content => "tag:test.host,2005:WeeksEvent/#{@weeks_events[0].id}")
  end

end
