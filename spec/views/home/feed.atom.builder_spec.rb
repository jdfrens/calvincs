require 'spec_helper'

describe "home/feed.atom.builder" do

  before do
    @newsitems = []
    @todays_events = []
    @weeks_events = []
    assign(:newsitems, @newsitems)
    assign(:todays_events, @todays_events)
    assign(:weeks_events, @weeks_events)
  end

  it "should have a title" do
    assign(:updated_at, Time.parse("March 7, 1970"))

    render

    rendered.should have_selector("feed") do |feed|
      feed.should have_selector("title",
                                :content => "Calvin College Computer Science - News and Events")
      feed.should have_selector("updated", :content => "1970-03-07")
    end
  end

  it "should render a news item" do
    @newsitems = [mock_model(Newsitem, :headline => "The Headline", :content => "The Body",
                             :goes_live_at => Time.parse("March 7, 1970"),
                             :updated_at => Time.now)]
    assign(:newsitems, @newsitems)

    render

    rendered.should have_selector("entry") do |entry|
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
                             :goes_live_at => Time.now, :updated_at => Time.now),
                  mock_model(Newsitem, :headline => "Headline 2", :content => "content",
                             :goes_live_at => Time.now, :updated_at => Time.now),
                  mock_model(Newsitem, :headline => "Headline 3", :content => "content",
                             :goes_live_at => Time.now, :updated_at => Time.now)]
    assign(:newsitems, @newsitems)

    render

    rendered.should have_selector("entry") do |entry|
      entry.should have_selector("title", :content => "Headline 1")
    end
    rendered.should have_selector("entry") do |entry|
      entry.should have_selector("title", :content => "Headline 2")
    end
    rendered.should have_selector("entry") do |entry|
      entry.should have_selector("title", :content => "Headline 3")
    end
  end

  it "should render an event for today" do
    @todays_events = [mock_model(Event, :full_title => "Full Event Title", :updated_at => Time.now)]
    assign(:todays_events, @todays_events)

    view.should_receive(:event_content_for_atom).with(@todays_events[0]).and_return("The content!")

    render

    rendered.should have_selector("entry") do |entry|
      entry.should have_selector("title", :content => "Full Event Title", :type => "html")
      entry.should have_selector("published", :content => Date.today.to_s)
      entry.should have_selector("updated")
      entry.should have_selector("content", :content => "The content!", :type => "html")
      entry.should have_selector("author") do |author|
        author.should have_selector("name", :content => "Computing@Calvin")
      end
    end
  end

  describe "render an event" do
    before(:each) do
      @todays_events = [mock_model(Event, :full_title => "Full Event Title", :updated_at => Time.now)]
      assign(:todays_events, @todays_events)

      view.should_receive(:event_content_for_atom).with(@todays_events[0]).and_return("event content!")

      render
    end

    it "should have a title" do
      rendered.should have_selector("entry title", :content => "Full Event Title")
    end

    it "should have content" do
      rendered.should have_selector("entry content", :content => "event content!")
    end

    it "should have a special id" do
      rendered.should have_selector("entry id", :content => "tag:test.host,2005:TodaysEvent/#{@todays_events[0].id}")
    end
  end

  it "should render multiple events for today" do
    @todays_events = [mock_model(Event, :full_title => "Today #1", :description => "#1", :updated_at => Time.now),
                      mock_model(Event, :full_title => "Today #2", :description => "#2", :updated_at => Time.now),
                      mock_model(Event, :full_title => "Today #3", :description => "#3", :updated_at => Time.now)]
    assign(:todays_events, @todays_events)

    view.stub(:event_content_for_atom)

    render

    rendered.should have_selector("entry") do |entry|
      entry.should have_selector("title", :content => "Today #1", :type => "html")
      entry.should have_selector("title", :content => "Today #2", :type => "html")
      entry.should have_selector("title", :content => "Today #3", :type => "html")
    end
  end

  it "should render an event for this week with a special id" do
    @weeks_events = [
      mock_model(Event, :full_title => "Next Week Is Now", :description => "Time travel!", :updated_at => Time.now)
      ]
    assign(:weeks_events, @weeks_events)

    view.stub(:event_content_for_atom)

    render

    rendered.should have_selector("entry id", :content => "tag:test.host,2005:WeeksEvent/#{@weeks_events[0].id}")
  end

end
