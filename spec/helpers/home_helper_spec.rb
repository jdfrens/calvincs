require 'spec_helper'

describe HomeHelper do

  helper :events

  describe "content of event's entry in atom feed" do
    before(:each) do
      event = mock_model(Event, :description => "Described event!", :location => "Room 42",
                                :presenter => "Dr. Phives", :timing => "sometime")

      helper.should_receive(:format_titles).with(event).and_return("Formatted Titles!")
      helper.should_receive(:event_details).with(event).and_return("details of the event!")
      helper.should_receive(:johnny_textilize).with("Described event!").and_return("Textilized description!")

      @result = helper.event_content_for_atom(event)
    end

    it "should have event titles" do
      @result.should have_selector("h1", :content => "Formatted Titles!")
    end

    it "should have event details" do
      @result.should contain("details of the event!")
    end

    it "should have a description" do
      @result.should contain("Textilized description!")
    end
  end

end
