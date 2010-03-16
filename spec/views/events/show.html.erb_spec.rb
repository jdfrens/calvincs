require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/events/view.html.erb" do

  describe "viewing a complete event" do

    before(:each) do
      start = mock("start time")
      event = mock(
              :title => "The Title", :subtitle => "The Subtitle", :start => start,
                      :presenter => "Dr. Presenter", :location => "Room 101",
                      :description => "The Description", :kind => "KindOfEvent")

      assigns[:event] = event
      expect_textilize_lite("The Title")
      expect_textilize_lite("The Subtitle")
      expect_textilize_lite("Dr. Presenter")
      start.should_receive(:to_s).with(:kindofevent).and_return("tomorrow at 8am")
      expect_textilize("The Description")

      render "events/show"
    end

    it "should have a complete title" do
      response.should have_selector("div#title") do |div|
        div.should have_selector("h1", :content => "The Title")
        div.should have_selector(".subtitle", :content => "The Subtitle")
      end
    end

    it "should have a presenter" do
      assert_select ".presenter", "Dr. Presenter"
    end

    it "should have a time" do
      response.should have_selector(".time", :content => "tomorrow at 8am")
    end

    it "should have a location" do
      response.should have_selector(".location", :content => "Room 101")
    end

    it "should have a description" do
      assert_select "div#event-description", "The Description"
    end
  end

  describe "viewing a minimal event" do
    before(:each) do
      event = mock_model(Event,
              :title => "The Title", :subtitle => nil,
              :presenter => nil, :location => nil,
              :description => "The Description")
      assigns[:event] = event
      expect_textilize_lite("The Title")
      expect_textilize("The Description")

      render "events/show"
    end

    it "should have minimal title" do
      response.should have_selector("#title") do |title|
        title.should have_selector("h1", :content => "The Title")
      end
      response.should_not have_selector("#subtitle")
    end

    it "should not have presenter" do
      response.should_not have_selector(".presenter")
    end

    it "should not have location" do
      response.should_not have_selector(".location")
    end

    it "should still have a description" do
      response.should have_selector("div#event-description", :content => "The Description")
    end
  end
 
end
