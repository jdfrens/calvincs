require 'spec_helper'

describe "/events/new.html.erb" do

  it "should render a form for a new colloquium" do
    event = mock_model(Colloquium, :kind => "Colloquium")
    assigns[:event] = event

    view.should_receive(:render).with(:partial => "form").and_return("the form")
    
    render 'events/new'

    rendered.should have_selector("h1", :content => "New Colloquium")
    rendered.should contain("the form")
  end

  it "should render a form for a new conference" do
    event = mock_model(Conference, :kind => "Conference")
    assigns[:event] = event

    view.should_receive(:render).with(:partial => "form").and_return("the form")

    render 'events/new'

    rendered.should have_selector("h1", :content => "New Conference")
    rendered.should contain("the form")
  end

end
