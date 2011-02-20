require 'spec_helper'

describe "courses/new.html.erb" do

  it "should render a form" do
    assign(:course, mock_model(Course))

    stub_template "courses/_form.html.erb" => "the form"

    render

    rendered.should have_selector("h1", :content => "Create Course")
    rendered.should contain("the form")
  end
end
