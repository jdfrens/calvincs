require 'spec_helper'

describe "/courses/edit" do

  it "should render a form" do
    view.should_receive(:render).with(:partial => "form").and_return("<p>the form</p>")

    render "/courses/edit"

    rendered.should have_selector("h1", :content => "Edit Course")
    rendered.should have_selector("p", :content => "the form")
  end
end
