require 'spec_helper'

describe "courses/_form.html.erb" do

  it "should render a form" do
    assign(:course, stub_model(Course))

    render

    rendered.should have_selector("form") do |form|
      form.should have_selector("select#course_department")
      form.should have_selector("input#course_number")
      form.should have_selector("input#course_title")
      form.should have_selector("input#course_url")
    end
  end

  it "should generate a create button for a new course" do
    assign(:course, Course.new)

    render

    rendered.should have_selector("input", :value => "Create")
  end

  it "should generate an update button for an edit" do
    assign(:course, stub_model(Course))

    render

    rendered.should have_selector("input", :value => "Update")
  end
end
