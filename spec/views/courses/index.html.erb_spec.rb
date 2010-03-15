require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/courses/index.html.erb" do

  it "should render a list" do
    assigns[:courses] = courses = [mock_model(Course), mock_model(Course), mock_model(Course)]

    template.should_receive(:link_to_online_materials).with(courses[0]).and_return("CS 101: foo")
    template.should_receive(:link_to_online_materials).with(courses[1]).and_return("CS 102: bar")
    template.should_receive(:link_to_online_materials).with(courses[2]).and_return("CS 103: foobar")

    expect_no_current_user

    render "/courses/index"

    response.should have_selector("h1", :content => "Courses")
    response.should have_selector("ul") do |ul|
      ul.should have_selector("li", :content => "CS 101: foo")
      ul.should have_selector("li", :content => "CS 102: bar")
      ul.should have_selector("li", :content => "CS 103: foobar")
    end
  end

  context "edit link" do
    it "should not render when not logged in"do
      assigns[:courses] = [mock_model(Course, :full_title => "CS 101: foo", :url => nil)]

      expect_no_current_user

      render "/courses/index"

      response.should_not contain("edit...")
    end

    it "should render with edit link when logged in" do
      assigns[:courses] = [mock_model(Course, :full_title => "CS 101: foo", :url => nil)]

      expect_some_current_user

      render "/courses/index"

      response.should have_selector("a", :content => "edit...")
    end
  end
end

