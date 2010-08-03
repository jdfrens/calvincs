require 'spec_helper'

describe "newsitems/index.html.erb" do

  it "should have a top-level header" do
    assign(:title, "Top Level Header")
    
    view.should_receive(:render2).with("news_listing").and_return("listing news items")
    view.should_receive(:render2).with("news_display").and_return("displaying news items")

    render

    rendered.should have_selector("h1", :content => "Top Level Header")
    rendered.should contain("listing news items")
    rendered.should contain("displaying news items")
  end
  
end
