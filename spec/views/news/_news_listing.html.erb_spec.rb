require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/news/_news_listing.html.erb" do

  it "should link to every news item" do
    news_items = [mock_model(NewsItem), mock_model(NewsItem), mock_model(NewsItem)]
    assigns[:news_items] = news_items

    template.should_receive(:link_to_current_news_item).with(news_items[0]).and_return("newsy 0")
    template.should_receive(:link_to_current_news_item).with(news_items[1]).and_return("newsy 1")
    template.should_receive(:link_to_current_news_item).with(news_items[2]).and_return("newsy 2")

    render "news/_news_listing"

    response.should have_selector("li", :content => "newsy 0")
    response.should have_selector("li", :content => "newsy 1")
    response.should have_selector("li", :content => "newsy 2")
    response.should have_selector("li a", :href => "/news?year=all", :content => "News Archive")
  end
end