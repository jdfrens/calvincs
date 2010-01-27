require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/personnel/edit.html.erb" do
  it "should render a form" do
    assigns[:user] = user = mock_model(User, :first_name => "First", :last_name => "Last",
                                       :email_address => "flast@example.com",
                                       :office_phone => "867-5309", :office_location => "somewhere",
                                       :job_title => "professor grande")

    render "personnel/edit"

    response.should have_selector("form") do |form|
      form.should have_selector("input", :id => "user_first_name")
      form.should have_selector("input", :id => "user_last_name")
      form.should have_selector("input", :id => "user_job_title")
      form.should have_selector("input", :id => "user_office_phone")
      form.should have_selector("input", :id => "user_office_location")
      form.should have_selector("input", :id => "user_email_address")
    end
  end
end
