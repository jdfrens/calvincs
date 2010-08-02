require 'spec_helper'

describe "/courses/new.html.erb" do

  it "should render a form" do
    assigns[:course] = mock_model(Course)

    view.should_receive(:render).with(:partial => "form").and_return("<p>form</p>")

    render "/courses/new"

    rendered.should have_selector("h1", :content => "Create Course")
    rendered.should have_selector("p", :content => "form")
  end
end
