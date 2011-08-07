require 'spec_helper'

describe "events/show.html.erb" do

  describe "viewing a complete event" do

    before(:each) do
      start = mock("start time")
      event = mock(
              :title => "The Title", :subtitle => "The Subtitle", :start => start,
                      :presenter => "Dr. Presenter", :location => "Room 101",
                      :description => "The Description", :event_kind => "KindOfEvent")

      assign(:event, event)
      expect_textilize_lite("The Title")
      expect_textilize_lite("The Subtitle")
      expect_textilize_lite("Dr. Presenter")
      start.should_receive(:to_s).with(:kindofevent).and_return("tomorrow at 8am")
      expect_textilize("The Description")

      render
    end

    it "should have a complete title" do
      rendered.should have_selector("div#title") do |div|
        div.should have_selector("h1", :content => "The Title")
        div.should have_selector(".subtitle", :content => "The Subtitle")
      end
    end

    it "should have a presenter" do
      rendered.should have_selector(".presenter", :content => "Dr. Presenter")
    end

    it "should have a time" do
      rendered.should have_selector(".time", :content => "tomorrow at 8am")
    end

    it "should have a location" do
      rendered.should have_selector(".location", :content => "Room 101")
    end

    it "should have a description" do
      rendered.should have_selector("#event-description", :content => "The Description")
    end
  end

  describe "viewing a minimal event" do
    before(:each) do
      event = mock_model(Event,
              :title => "The Title", :subtitle => nil,
              :presenter => nil, :location => nil,
              :description => "The Description")
      assign(:event, event)
      expect_textilize_lite("The Title")
      expect_textilize("The Description")

      render
    end

    it "should have minimal title" do
      rendered.should have_selector("#title") do |title|
        title.should have_selector("h1", :content => "The Title")
      end
      rendered.should_not have_selector("#subtitle")
    end

    it "should not have presenter" do
      rendered.should_not have_selector(".presenter")
    end

    it "should not have location" do
      rendered.should_not have_selector(".location")
    end

    it "should still have a description" do
      rendered.should have_selector("div#event-description", :content => "The Description")
    end
  end
end
