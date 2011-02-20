require 'spec_helper'

describe "images/edit.html.erb" do
  it "should render a form from a partial" do
    stub_template "images/_form.html.erb" => "the form"

    render

    rendered.should contain("the form")
  end
end
