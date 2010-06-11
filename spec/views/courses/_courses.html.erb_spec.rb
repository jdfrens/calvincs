require 'spec_helper'

describe "/courses/_courses.html.erb" do

  it "should render a list" do
    courses = [mock_model(Course), mock_model(Course), mock_model(Course)]

    template.should_receive(:courses).any_number_of_times.and_return(courses)
    template.should_receive(:link_to_online_materials).with(courses[0]).and_return("CS 101: foo")
    template.should_receive(:link_to_online_materials).with(courses[1]).and_return("CS 102: bar")
    template.should_receive(:link_to_online_materials).with(courses[2]).and_return("CS 103: foobar")
    expect_no_current_user

    render "/courses/_courses"

    response.should have_selector("ul") do |ul|
      ul.should have_selector("li", :content => "CS 101: foo")
      ul.should have_selector("li", :content => "CS 102: bar")
      ul.should have_selector("li", :content => "CS 103: foobar")
    end
  end

  context "management links" do
    it "should not render when not logged in"do
      courses = [mock_model(Course, :full_title => "CS 101: foo", :url => nil)]

      template.should_receive(:courses).any_number_of_times.and_return(courses)
      expect_no_current_user

      render "/courses/_courses"

      response.should_not contain("edit...")
      response.should_not contain("delete...")
    end

    it "should render with edit link when logged in" do
      courses = [mock_model(Course, :full_title => "CS 101: foo", :url => nil)]

      template.should_receive(:courses).any_number_of_times.and_return(courses)
      expect_some_current_user

      render "/courses/_courses"

      response.should have_selector("a", :content => "edit...")
      response.should have_selector("a", :content => "delete...")
    end
  end
end

