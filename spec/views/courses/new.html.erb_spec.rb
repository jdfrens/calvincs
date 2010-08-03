require 'spec_helper'

describe "courses/new.html.erb" do

  it "should render a form" do
    assign(:course, mock_model(Course))

    view.should_receive(:render2).with(:partial => "form").and_return("form")

    render

    rendered.should have_selector("h1", :content => "Create Course")
    rendered.should contain("form")
  end
end
