require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/newsitems/index.html.erb" do

  it "should have a top-level header" do
    assigns[:title] = "Top Level Header"
    template.should_receive(:render).with(:partial => "news_listing").and_return("listing news items")
    template.should_receive(:render).with(:partial => "news_display").and_return("displaying news items")

    render "newsitems/index"

    response.should have_selector("h1", :content => "Top Level Header")
    response.should contain("listing news items")
    response.should contain("displaying news items")
  end
  
end