require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/personnel/edit.html.erb" do
  it "should render a form" do
    assigns[:user] = user = mock_model(User, :first_name => "First", :last_name => "Last",
                                       :email_address => "flast@example.com",
                                       :office_phone => "867-5309", :office_location => "somewhere",
                                       :job_title => "professor grande")

    user.should_receive(:page_identifier).any_number_of_times.
            with(anything).and_return("some identifier")
    
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

  it "should render editing links" do
    assigns[:user] = user = mock_model(User, :first_name => "First", :last_name => "Last",
                                       :email_address => "flast@example.com",
                                       :office_phone => "867-5309", :office_location => "somewhere",
                                       :job_title => "professor grande")

    user.should_receive(:page_identifier).with("interests").
            at_least(:once).and_return("interests identifier")
    user.should_receive(:page_identifier).with("status").
            at_least(:once).and_return("status identifier")
    user.should_receive(:page_identifier).with("profile").
            at_least(:once).and_return("profile identifier")

    render "personnel/edit"

    response.should have_selector("a", :href => edit_page_path("interests identifier"), :content => "edit interests")
    response.should have_selector("a", :href => edit_page_path("status identifier"), :content => "edit status")
    response.should have_selector("a", :href => edit_page_path("profile identifier"), :content => "edit profile")
  end

  it "should render deleting links" do
    assigns[:user] = user = mock_model(User, :first_name => "First", :last_name => "Last",
                                       :email_address => "flast@example.com",
                                       :office_phone => "867-5309", :office_location => "somewhere",
                                       :job_title => "professor grande")

    user.should_receive(:page_identifier).with("interests").
            at_least(:once).and_return("interests_identifier")
    user.should_receive(:page_identifier).with("status").
            at_least(:once).and_return("status_identifier")
    user.should_receive(:page_identifier).with("profile").
            at_least(:once).and_return("profile_identifier")

    render "personnel/edit"

    response.should have_selector("a", :href => page_path("interests_identifier"), :content => "delete interests")
    response.should have_selector("a", :href => page_path("status_identifier"), :content => "delete status")
    response.should have_selector("a", :href => page_path("profile_identifier"), :content => "delete profile")
  end  
end
