require 'spec_helper'

describe "newsitems/index.html.erb" do

  it "should have a top-level header" do
    assign(:title, "Top Level Header")

    stub_template "newsitems/_news_listing.html.erb" => "listing news items"
    stub_template "newsitems/_news_display.html.erb" => "displaying news items"

    render

    rendered.should have_selector("h1", :content => "Top Level Header")
    rendered.should contain("listing news items")
    rendered.should contain("displaying news items")
  end

end
