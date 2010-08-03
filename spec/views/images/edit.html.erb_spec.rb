require 'spec_helper'

describe "images/edit.html.erb" do
  it "should render a form from a partial" do
    view.should_receive(:render2).with(:partial => "form").and_return("the form")

    render

    rendered.should contain("the form")
  end
end
