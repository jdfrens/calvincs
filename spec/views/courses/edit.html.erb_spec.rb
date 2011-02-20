require 'spec_helper'

describe "courses/edit" do

  it "should render a form" do
    stub_template "courses/_form.html.erb" => 'the form'

    render

    rendered.should have_selector("h1", :content => "Edit Course")
    rendered.should contain("the form")
  end
end
