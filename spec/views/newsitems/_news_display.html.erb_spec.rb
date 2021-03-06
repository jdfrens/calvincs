require 'spec_helper'

describe "newsitems/_news_display.html.erb" do

  it "should display a news item" do
    live_at = mock("live at date")
    news_item = mock_model(Newsitem, :headline => "The Headline of Love",
            :goes_live_at => live_at,
            :content => "The beautiful content is awesome!")
    assign(:newsitems, [news_item])
    
    live_at.should_receive(:to_s).with(:news_posted).and_return("the date when it was posted")
    expect_textilize("The beautiful content is awesome!")
    view.stub!(:current_user).and_return(false)

    render

    rendered.should have_selector("h2", :content => "The Headline of Love")
    rendered.should have_selector(".goes-live-date", :content => "Posted on the date when it was posted")
    rendered.should have_selector(".content", :content => "The beautiful content is awesome!")
  end

  it "should display many news items" do
    news_items = [stub_model(Newsitem, :headline => "Headline #1", :content => "Content #1", :goes_live_at => Time.now),
            stub_model(Newsitem, :headline => "Headline B", :content => "Content B", :goes_live_at => Time.now),
            stub_model(Newsitem, :headline => "Headline gamma", :content => "Content gamma", :goes_live_at => Time.now)]
    assign(:newsitems, news_items)

    view.stub!(:current_user).and_return(false)

    render

    rendered.should have_selector("h2", :content => "Headline #1")
    rendered.should have_selector("h2", :content => "Headline B")
    rendered.should have_selector("h2", :content => "Headline gamma")
    rendered.should_not contain("edit...")
  end

  it "should have links to edit news items when logged in" do
    news_item = mock_model(Newsitem, :headline => "h",
            :goes_live_at => Time.now,
            :content => "c")
    assign(:newsitems, [news_item])

    view.should_receive(:current_user).and_return(true)

    render

    rendered.should have_selector("a", :href => "/newsitems/#{news_item.id}/edit", :content => "edit...")
  end
end
