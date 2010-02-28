require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/personnel/edit.html.erb" do
  it "should render a form" do
    assigns[:user] = user = mock_model(User, :first_name => "First", :last_name => "Last", :username => "flast",
                                       :role_id => 5,
                                       :email_address => "flast@example.com",
                                       :office_phone => "867-5309", :office_location => "somewhere",
                                       :job_title => "professor grande")

    template.should_receive(:render).with(:partial => "edit_page_links", :locals => anything).
            at_least(:once).and_return("page links")
    
    render "personnel/edit"

    response.should have_selector("form") do |form|
      form.should have_selector("input", :id => "user_first_name")
      form.should have_selector("input", :id => "user_last_name")
      form.should have_selector("select", :id => "user_role_id")
      form.should have_selector("input", :id => "user_job_title")
      form.should have_selector("input", :id => "user_office_phone")
      form.should have_selector("input", :id => "user_office_location")
      form.should have_selector("input", :id => "user_email_address")
    end
  end

  it "should render a editing links" do
    assigns[:user] = user = mock_model(User, :first_name => "First", :last_name => "Last", :username => "flast",
                                       :role_id => 5,
                                       :email_address => "flast@example.com",
                                       :office_phone => "867-5309", :office_location => "somewhere",
                                       :job_title => "professor grande")

    template.should_receive(:render).with(:partial => "edit_page_links", :locals => { :page_type => "interests" }).
            and_return("interests links")
    template.should_receive(:render).with(:partial => "edit_page_links", :locals => { :page_type => "profile" }).
            and_return("profile links")
    template.should_receive(:render).with(:partial => "edit_page_links", :locals => { :page_type => "status" }).
            and_return("status links")

    render "personnel/edit"

    response.should contain("interests links")
    response.should contain("profile links")
    response.should contain("status links")
  end
end
