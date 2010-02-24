require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/images/edit.html.erb" do
  it "should render a form from a partial" do
    template.should_receive(:render).with(:partial => "form").and_return("the form")

    render "/images/edit"

    response.should contain("the form")
  end
end
