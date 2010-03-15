require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/courses/index.html.erb" do

  it "should render three lists" do
    assigns[:cs_courses] = cs_courses = mock("array of cs courses")
    assigns[:is_courses] = is_courses = mock("array of is courses")
    assigns[:interim_courses] = interim_courses = mock("array of interim courses")

    template.should_receive(:render).with(:partial => "courses", :locals => {:courses => cs_courses}).
            and_return("a listing of the cs courses")
    template.should_receive(:render).with(:partial => "courses", :locals => {:courses => is_courses}).
            and_return("a listing of the is courses")
    template.should_receive(:render).with(:partial => "courses", :locals => {:courses => interim_courses}).
            and_return("a listing of the interim courses")

    render "/courses/index"

    response.should have_selector("h1", :content => "Courses")
    response.should contain("a listing of the cs courses")
    response.should contain("a listing of the is courses")
    response.should contain("a listing of the interim courses")
  end

end
