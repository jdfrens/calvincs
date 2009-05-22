require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do
  
  fixtures :users

  it "should have a login form" do
    get :login

    response.should be_success
    response.should render_template("users/login")
    flash.should be_empty
  end

  it "should redirect after successful login" do
    post :login, :user => { :username => 'calvin', :password => 'calvinpassword' }

    assert_redirected_to :controller => 'home', :action => 'administrate'
    assert flash.empty?
  end

  it "should show the form when login is bad" do
    post :login, :user => { :username => 'calvin', :password => 'BAD PASSWORD' }

    response.should be_success
    flash.now.should == "Invalid login credentials"
  end
  
end
