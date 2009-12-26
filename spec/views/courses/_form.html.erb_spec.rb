require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/courses/_form.html.erb" do

  it "should render a form" do
    assigns[:course] = Factory.build(:course)
    
    render "/courses/_form"

    response.should have_selector("form") do |form|
      form.should have_selector("input#course_department")
      form.should have_selector("input#course_number")
      form.should have_selector("input#course_title")
      form.should have_selector("input#course_credits")
      form.should have_selector("textarea#course_description")
    end
  end
end
