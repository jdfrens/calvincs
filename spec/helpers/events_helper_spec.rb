require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EventsHelper do

  describe "formatting a title" do
    it "should format a title and subtitle" do
      event = mock("event", :title => "The Title", :subtitle => "The Subtitle")
      helper.should_receive(:johnny_textilize).with("The Title", :no_paragraphs).and_return("The Title")
      helper.should_receive(:johnny_textilize).with("The Subtitle", :no_paragraphs).and_return("The Subtitle")

      helper.format_titles(event).should ==
              "<span class=title>The Title</span>: <br /><span class=subtitle>The Subtitle</span>"
    end

    it "should format a title without a subtitle" do
      event = mock("event", :title => "The Title", :subtitle => "")
      helper.should_receive(:johnny_textilize).with("The Title", :no_paragraphs).and_return("The Title")

      helper.format_titles(event).should == "<span class=title>The Title</span>"
    end
  end
end
