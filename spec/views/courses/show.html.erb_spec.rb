require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/courses/show.html.erb" do

  it "should show a course" do
    assigns[:course] = mock_model(Course, :identifier => "CS 108",
                                  :title => "Introduction to Computing", :credits => 4,
                                  :description => "The standard CS 1 class.")
    
    render "/courses/show"

    response.should have_selector("h1", :content => "CS 108: Introduction to Computing")
    response.should have_selector("p", :content => "4 credits")
    response.should have_selector("p", :content => "The standard CS 1 class.")
  end
end
