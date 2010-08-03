require 'spec_helper'

describe "courses/edit" do

  it "should render a form" do
    view.should_receive(:render2).with(:partial => "form").and_return("the form")

    render

    rendered.should have_selector("h1", :content => "Edit Course")
    rendered.should contain("the form")
  end
end
