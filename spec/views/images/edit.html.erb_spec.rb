require 'spec_helper'

describe "/images/edit.html.erb" do
  it "should render a form from a partial" do
    view.should_receive(:render).with(:partial => "form").and_return("the form")

    render "/images/edit"

    rendered.should contain("the form")
  end
end
