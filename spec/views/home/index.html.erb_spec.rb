require 'spec_helper'

describe "home/index.html.erb" do

  it "should render the home page" do
    content = mock_model(Page)
    todays_events = mock("today_events")
    this_weeks_events = mock("week_events")
    newsitems = mock("news items")
    assign(:splash_image, mock_model(Image, :url => "/images/foobar.jpg", :caption => "The caption!"))
    assign(:content, content)
    assign(:todays_events, todays_events)
    assign(:this_weeks_events, this_weeks_events)
    assign(:newsitems, newsitems)

    expect_textilize_lite("The caption!", "Textilized caption!")
    view.should_receive(:render2).with(:partial => "homepage_splash.js").and_return("splash")
    view.should_receive(:render2).
      with(:partial => "shared/subpage", :locals => { :page => content }).
      and_return("The real content!")
    view.should_receive(:render2).
      with(:partial => "event", :collection => todays_events, 
           :locals => { :timing => "today" }).
      and_return("The events of today...")
    view.should_receive(:render2).
      with(:partial => "event", :collection => this_weeks_events, 
           :locals => { :timing => "coming up" }).
      and_return("The events of this week...")
    view.should_receive(:render2).
      with(:partial => "newsitem", :collection => newsitems).
      and_return("news items...")

    render

    rendered.should have_selector("#home_splash") do |home_splash|
      home_splash.should have_selector("img", :src => "/images/foobar.jpg")
      home_splash.should have_selector("#splash-description", :content => "Textilized caption!")
    end
    rendered.should contain("The real content!")
    rendered.should contain("The events of today...")
    rendered.should contain("The events of this week...")
    rendered.should contain("news items...")
  end
end
