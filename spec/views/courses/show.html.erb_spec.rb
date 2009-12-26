require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/courses/show.html.erb" do

  it "should show a course" do
    assigns[:course] = mock_model(Course, :credits => 4,
                                  :full_title => "CS 108: Introduction to Computing",
                                  :description => "The standard CS 1 class.")
    
    render "/courses/show"

    response.should have_selector("h1", :content => "CS 108: Introduction to Computing")
    response.should_not have_selector("a", :content => "edit")
    response.should have_selector("p", :content => "4 credits")
    response.should have_selector("p", :content => "The standard CS 1 class.")
  end

  it "should have an edit link when logged in" do
    assigns[:course] = mock_model(Course, :credits => 4,
                                  :full_title => "CS 108: Introduction to Computing",
                                  :description => "The standard CS 1 class.")

    template.should_receive(:current_user).and_return(mock_model(User))

    render "/courses/show"

    response.should have_selector("a", :content => "edit")
  end
end
