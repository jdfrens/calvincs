require 'spec_helper'

describe "home/index.html.erb" do

  it "should render the home page" do
    content = mock_model(Page, :stubbed_content => "The real content!")
    todays_events = [mock("today_events")]
    this_weeks_events =[ mock("week_events")]
    newsitems = [mock("news items")]
    assign(:splash_image, mock_model(Image, :url => "/images/foobar.jpg", :caption => "The caption!"))
    assign(:content, content)
    assign(:todays_events, todays_events)
    assign(:this_weeks_events, this_weeks_events)
    assign(:newsitems, newsitems)

    expect_textilize_lite("The caption!", "Textilized caption!")
    stub_template "home/_homepage_splash.js.erb" => "splash"
    stub_template "shared/_subpage.html.erb" => "<%= page.stubbed_content %>"
    stub_template "home/_event.html.erb" => "The events <%= timing %>."
    stub_template "home/_newsitem.html.erb" => "news items..."

    render

    rendered.should have_selector("#home_splash") do |home_splash|
      home_splash.should have_selector("img", :src => "/images/foobar.jpg")
      home_splash.should have_selector("#splash-description", :content => "Textilized caption!")
    end
    rendered.should contain("The real content!")
    rendered.should contain("The events today.")
    rendered.should contain("The events coming up.")
    rendered.should contain("news items...")
  end
end
