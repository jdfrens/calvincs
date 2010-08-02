require 'spec_helper'

describe "/newsitems/_news_listing.html.erb" do

  it "should link to every news item" do
    news_items = [mock_model(Newsitem), mock_model(Newsitem), mock_model(Newsitem)]
    assigns[:newsitems] = news_items

    view.should_receive(:link_to_current_newsitem).with(news_items[0]).and_return("newsy 0")
    view.should_receive(:link_to_current_newsitem).with(news_items[1]).and_return("newsy 1")
    view.should_receive(:link_to_current_newsitem).with(news_items[2]).and_return("newsy 2")

    render "newsitems/_news_listing"

    rendered.should have_selector("li", :content => "newsy 0")
    rendered.should have_selector("li", :content => "newsy 1")
    rendered.should have_selector("li", :content => "newsy 2")
    rendered.should have_selector("li a", :href => "/newsitems?year=all", :content => "News Archive")
  end
end
