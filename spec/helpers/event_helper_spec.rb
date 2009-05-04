require "spec"

describe EventHelper do

  describe "formatting a title" do
    it "should format a title and subtitle" do
      event = mock("event", :title => "The Title", :subtitle => "The Subtitle")

      helper.format_titles(event).should ==
              "<span class=title>The Title</span>: <br /><span class=subtitle>The Subtitle</span>"
    end

    it "should format a title without a subtitle" do
      event = mock("event", :title => "The Title", :subtitle => "")

      helper.format_titles(event).should == "<span class=title>The Title</span>"
    end
  end
end