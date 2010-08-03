require 'spec_helper'

describe "courses/show.html.erb" do

  it "should show a course" do
    assign(:course, mock_model(Course, :full_title => "CS 108: Introduction to Computing"))

    view.should_receive(:current_user).and_return(nil)

    render

    rendered.should have_selector("h1", :content => "CS 108: Introduction to Computing")
    rendered.should_not have_selector("a", :content => "edit")
  end

  it "should have an edit link when logged in" do
    assign(:course, mock_model(Course, :full_title => "CS 108: Introduction to Computing"))

    view.should_receive(:current_user).and_return(mock_model(User))

    render

    rendered.should have_selector("a", :content => "edit")
  end
end
