require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/users/login.html.erb" do
  it "should render a form" do
    render "users/login"

    assert_select "h1", "Log In"
    assert_select "input#user_username[type=text]"
    assert_select "input#user_password[type=password]"
    assert_select "input[type=submit]"    
  end
end