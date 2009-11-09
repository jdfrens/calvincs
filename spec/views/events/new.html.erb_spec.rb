require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/events/new.html.erb" do

  it "should render a form for a new colloquium" do
    event = mock_model(Colloquium, :kind => "Colloquium")
    assigns[:event] = event

    template.should_receive(:render).with(:partial => "form").and_return("the form")
    
    render 'events/new'

    response.should have_selector("h1", :content => "New Colloquium")
    response.should contain("the form")
  end

  it "should render a form for a new conference" do
    event = mock_model(Conference, :kind => "Conference")
    assigns[:event] = event

    template.should_receive(:render).with(:partial => "form").and_return("the form")

    render 'events/new'

    response.should have_selector("h1", :content => "New Conference")
    response.should contain("the form")
  end

end
