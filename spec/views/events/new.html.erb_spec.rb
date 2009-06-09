require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/events/new.html.erb" do

  it "should render a form for a new event" do
    event = mock_model(Event)
    assigns[:event] = event

    template.should_receive(:render).with(:partial => "form").and_return("the form")
    
    render 'events/new'

    assert_select "h1", "New Event"
    response.should contain("the form")
  end

end
