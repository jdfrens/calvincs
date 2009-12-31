require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/courses/index.html.erb" do

  it "should render a list" do
    assigns[:courses] = [
            mock_model(Course, :identifier => "CS 101", :title => "foo"),
            mock_model(Course, :identifier => "CS 102", :title => "bar"),
            mock_model(Course, :identifier => "CS 103", :title => "foobar")
    ]

    render "/courses/index"

    response.should have_selector("h1", :content => "Courses")
    response.should have_selector("ul") do |ul|
      ul.should have_selector("li", :content => "CS 101: foo")
      ul.should have_selector("li", :content => "CS 102: bar")
      ul.should have_selector("li", :content => "CS 103: foobar")
    end
  end

  it "should render with links" do
    course = mock_model(Course, :identifier => "CS 101", :title => "foo")
    assigns[:courses] = [course]

    render "/courses/index"

    response.should have_selector("ul") do |ul|
      ul.should have_selector("a", :href => "/courses/#{course.id}", :content => "CS 101: foo")
    end
  end
end

