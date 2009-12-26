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

  it "should generate a create button for a new course" do
    assigns[:course] = Course.new

    render "/courses/_form"

    response.should have_selector("input", :value => "Create")
  end

  it "should generate an update button for an edit" do
    assigns[:course] = Factory.create(:course)

    render "/courses/_form"

    response.should have_selector("input", :value => "Update")
  end
end
