require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/home/index.html.erb" do

  it "should render the home page" do
    assigns[:splash_image] = mock_model(Image, :url => "/images/foobar.jpg")
    assigns[:content] = mock_model(Page)
    assigns[:todays_events] = mock("today_events")
    assigns[:this_weeks_events] = mock("week_events")
    assigns[:newsitems] = mock("news items")

    template.should_receive(:render).
            with(:partial => "shared/subpage", :locals => { :page => assigns[:content] }).
            and_return("content!!")
    template.should_receive(:render).
            with(:partial => "event", :collection => assigns[:todays_events], :locals => { :timing => "today" }).
            and_return("content!!")
    template.should_receive(:render).
            with(:partial => "event", :collection => assigns[:this_weeks_events], :locals => { :timing => "this week" }).
            and_return("content!!")
    template.should_receive(:render).
            with(:partial => "newsitem" , :collection => assigns[:newsitems]).
            and_return("content!!")

    render "home/index"

    response.should have_selector("img", :src => "/images/foobar.jpg")
  end

end

