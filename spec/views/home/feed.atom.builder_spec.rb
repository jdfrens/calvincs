require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/home/feed.atom.builder" do

  it "should have a title" do
    assigns[:newsitems] = []
    
    render "/home/feed.atom"

    response.should have_selector("title", :content => "Calvin College Computer Science - News and Events")
  end
  
  it "should render a news item" do
    newsitems = [mock_model(Newsitem, :headline => "The Headline", :content => "The Body",
                            :goes_live_at => Time.parse("March 7, 1970"))]
    assigns[:newsitems] = newsitems

    render "/home/feed.atom"

    response.should have_selector("entry") do |entry|
      entry.should have_selector("title", :content => "The Headline")
      entry.should have_selector("published", :content => "1970-03-07")
      entry.should have_selector("content", :content => "The Body")
    end
  end
  
  it "should render multiple news items" do
    newsitems = [mock_model(Newsitem, :headline => "Headline 1", :content => "content",
                            :goes_live_at => Time.now),
                 mock_model(Newsitem, :headline => "Headline 2", :content => "content",
                            :goes_live_at => Time.now),
                 mock_model(Newsitem, :headline => "Headline 3", :content => "content",
                            :goes_live_at => Time.now)]
    assigns[:newsitems] = newsitems

    render "/home/feed.atom"

    response.should have_selector("entry") do |entry|
      entry.should have_selector("title", :content => "Headline 1")
      entry.should have_selector("title", :content => "Headline 2")
      entry.should have_selector("title", :content => "Headline 3")
    end
  end

end