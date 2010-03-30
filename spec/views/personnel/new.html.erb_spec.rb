require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/personnel/new.html.erb" do
  it "should render a form" do
    assigns[:user] = user = User.new

    render "personnel/new"

    response.should have_selector("form") do |form|
      form.should have_selector("input", :id => "user_first_name")
      form.should have_selector("input", :id => "user_last_name")
      form.should have_selector("select", :id => "user_role_id")
      form.should have_selector("input", :id => "user_username")
      form.should have_selector("input", :id => "user_password")
      form.should have_selector("input", :id => "user_password_confirmation")
    end
  end
end
