require 'spec_helper'

describe "personnel/new.html.erb" do
  it "should render a form" do
    assign(:user, User.new)

    render

    rendered.should have_selector("form") do |form|
      form.should have_selector("input", :id => "user_first_name")
      form.should have_selector("input", :id => "user_last_name")
      form.should have_selector("select", :id => "user_role_id")
      form.should have_selector("input", :id => "user_username")
      form.should have_selector("input", :id => "user_password")
      form.should have_selector("input", :id => "user_password_confirmation")
    end
  end
end
