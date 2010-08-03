require 'spec_helper'

describe "courses/index.html.erb" do

  it "should render three lists" do
    cs_courses = mock("array of cs courses")
    is_courses = mock("array of is courses")
    interim_courses = mock("array of interim courses")
    assign(:cs_courses, cs_courses)
    assign(:is_courses, is_courses)
    assign(:interim_courses, interim_courses)

    view.should_receive(:render2).
      with(:partial => "courses", :locals => {:courses => cs_courses}).
      and_return("a listing of the cs courses")
    view.should_receive(:render2).
      with(:partial => "courses", :locals => {:courses => is_courses}).
      and_return("a listing of the is courses")
    view.should_receive(:render2).
      with(:partial => "courses", :locals => {:courses => interim_courses}).
      and_return("a listing of the interim courses")

    render

    rendered.should have_selector("h1", :content => "Courses")
    rendered.should contain("a listing of the cs courses")
    rendered.should contain("a listing of the is courses")
    rendered.should contain("a listing of the interim courses")
  end

end
