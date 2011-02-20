require 'spec_helper'

describe "courses/index.html.erb" do

  it "should render three lists" do
    cs_courses = mock("array of cs courses", :stubbed_content => "a listing of the cs courses")
    is_courses = mock("array of is courses", :stubbed_content => "a listing of the is courses")
    interim_courses = mock("array of interim courses", :stubbed_content => "a listing of the interim courses")
    assign(:cs_courses, cs_courses)
    assign(:is_courses, is_courses)
    assign(:interim_courses, interim_courses)

    stub_template "courses/_courses.html.erb" => "<%= courses.stubbed_content %>"

    render

    rendered.should have_selector("h1", :content => "Courses")
    rendered.should contain("a listing of the cs courses")
    rendered.should contain("a listing of the is courses")
    rendered.should contain("a listing of the interim courses")
  end

end
