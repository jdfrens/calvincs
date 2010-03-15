require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/courses/index.html.erb" do

  it "should render a list" do
    assigns[:courses] = [
            mock_model(Course, :full_title => "CS 101: foo"),
            mock_model(Course, :full_title => "CS 102: bar"),
            mock_model(Course, :full_title => "CS 103: foobar")
    ]

    expect_no_current_user

    render "/courses/index"

    response.should have_selector("h1", :content => "Courses")
    response.should have_selector("ul") do |ul|
      ul.should have_selector("li", :content => "CS 101: foo")
      ul.should have_selector("li", :content => "CS 102: bar")
      ul.should have_selector("li", :content => "CS 103: foobar")
    end
  end

  it "should render with links" do
    course = mock_model(Course, :full_title => "CS 101: foo")
    assigns[:courses] = [course]

    expect_no_current_user

    render "/courses/index"

    response.should have_selector("ul") do |ul|
      ul.should have_selector("a", :href => "/courses/#{course.id}", :content => "CS 101: foo")
    end
    response.should_not contain("edit...")
  end


  it "should render with edit link when logged in" do
    course = mock_model(Course, :full_title => "CS 101: foo")
    assigns[:courses] = [course]

    expect_some_current_user

    render "/courses/index"

    response.should have_selector("a", :content => "edit...")
  end
end

