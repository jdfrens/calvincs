require 'spec_helper'

describe "events/new.html.erb" do

  it "should render a form for a new colloquium" do
    event = mock_model(Colloquium, :kind => "Colloquium")
    assign(:event, event)

    stub_template "events/_form.html.erb" => "the form"

    render

    rendered.should have_selector("h1", :content => "New Colloquium")
    rendered.should contain("the form")
  end

  it "should render a form for a new conference" do
    event = mock_model(Conference, :kind => "Conference")
    assign(:event, event)

    stub_template "events/_form.html.erb" => "the form"

    render

    rendered.should have_selector("h1", :content => "New Conference")
    rendered.should contain("the form")
  end

end
