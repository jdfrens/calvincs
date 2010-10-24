require 'spec_helper'

describe EventsHelper do

  describe "formatting a title" do
    it "should format a title and subtitle" do
      event = mock("event", :title => "The Title", :subtitle => "The Subtitle")
      helper.should_receive(:johnny_textilize_lite).with("The Title").and_return("The Title")
      helper.should_receive(:johnny_textilize_lite).with("The Subtitle").and_return("The Subtitle")

      titles = helper.format_titles(event)
      titles.should ==
              '<span class="title">The Title</span>: <br /><span class="subtitle">The Subtitle</span>'
      titles.should be_html_safe
    end

    it "should format a title without a subtitle" do
      event = mock("event", :title => "The Title", :subtitle => "")
      helper.should_receive(:johnny_textilize_lite).with("The Title").and_return("The Title")

      titles = helper.format_titles(event)
      titles.should == '<span class="title">The Title</span>'
      titles.should be_html_safe
    end
  end
end
