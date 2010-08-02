require 'spec_helper'

describe "/home/index.html.erb" do

  it "should render the home page" do
    assigns[:splash_image] = mock_model(Image, :url => "/images/foobar.jpg", :caption => "The caption!")
    assigns[:content] = mock_model(Page)
    assigns[:todays_events] = mock("today_events")
    assigns[:this_weeks_events] = mock("week_events")
    assigns[:newsitems] = mock("news items")

    view.should_receive(:johnny_textilize_lite).with("The caption!").and_return("Textilized caption!")
    view.should_receive(:render).
            with(:partial => "shared/subpage", :locals => { :page => assigns[:content] }).
            and_return("The real content!")
    view.should_receive(:render).
            with(:partial => "event", :collection => assigns[:todays_events], :locals => { :timing => "today" }).
            and_return("The events of today...")
    view.should_receive(:render).
            with(:partial => "event", :collection => assigns[:this_weeks_events], :locals => { :timing => "coming up" }).
            and_return("The events of this week...")
    view.should_receive(:render).
            with(:partial => "newsitem", :collection => assigns[:newsitems]).
            and_return("news items...")

    render "home/index"

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
