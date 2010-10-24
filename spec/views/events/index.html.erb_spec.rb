require 'spec_helper'

describe "events/index.html.erb" do

  describe "rendering an event" do
    before(:each) do
      timing = mock("timing", :to_s => "the timing")
      @event = mock_model(Event, :timing => timing, :presenter => "Charles M. Ruby",
                                 :location => "Room 101")
      assign(:events, [@event])
      assign(:title, "The Title")
      view.should_receive(:format_titles).with(@event).and_return("the titles!")
      view.stub!(:current_user).and_return(false)

      render
    end

    it "should have a header" do
      rendered.should have_selector("h1", :content => "The Title")
    end

    it "should have a title" do
      assert_select "div#event-#{@event.id}" do
        assert_select "h2", /the titles!/
      end
    end

    it "should have a presenter" do
      rendered.should have_selector(".presenter", :content => "Charles M. Ruby")
    end

    it "should have a location" do
      rendered.should have_selector(".location", :content => "Room 101")
    end

    it "should have a time" do
      assert_select "div#event-#{@event.id}" do
        assert_select ".when", "the timing"
      end
    end

    it "should have a more link" do
      rendered.should have_selector("a", :href => "/events/#{@event.id}", :content => "more...")
    end
  end

  describe "rendering an event" do
    before(:each) do
      timing = mock("timing", :to_s => "the timing")
      @event = mock_model(Event, :timing => timing, :presenter => nil, :location => nil)
      assign(:events, [@event])
      assign(:title, "The Title")
      view.should_receive(:format_titles).with(@event).and_return("the titles!")
      view.stub!(:current_user).and_return(false)

      render
    end

    it "should not have a presenter" do
      rendered.should_not have_selector(".presenter")
    end

    it "should not have a location" do
      rendered.should_not have_selector(".location")
    end

  end
end
