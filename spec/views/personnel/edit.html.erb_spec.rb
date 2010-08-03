require 'spec_helper'

describe "personnel/edit.html.erb" do
  it "should render a form" do
    user = mock_model(User, :first_name => "First", :last_name => "Last", :username => "flast",
                           :role_id => 5,
                           :email_address => "flast@example.com",
                           :office_phone => "867-5309", :office_location => "somewhere",
                           :job_title => "professor grande",
                           :degrees => [])
    assign(:user, user)

    view.should_receive(:render2).with("degree_fields", hash_including(:form)).
      and_return("degree fields")
    view.should_receive(:render2).
      with(:partial => "edit_page_links", :locals => { :page_type => "interests" }).
      and_return("interests links")
    view.should_receive(:render2).
      with(:partial => "edit_page_links", :locals => { :page_type => "profile" }).
      and_return("profile links")
    view.should_receive(:render2).
      with(:partial => "edit_page_links", :locals => { :page_type => "status" }).
      and_return("status links")
    
    render

    rendered.should have_selector("form") do |form|
      form.should have_selector("input", :id => "user_first_name")
      form.should have_selector("input", :id => "user_last_name")
      form.should have_selector("select", :id => "user_role_id")
      form.should have_selector("input", :id => "user_job_title")
      form.should have_selector("input", :id => "user_office_phone")
      form.should have_selector("input", :id => "user_office_location")
      form.should have_selector("input", :id => "user_email_address")
    end
    rendered.should have_selector("a", :content => "change password...")
    rendered.should contain("interests links")
    rendered.should contain("profile links")
    rendered.should contain("status links")
  end
end
