require 'spec_helper'

describe UsersController do

  user_fixtures

  describe "logging in" do
    it "should have a login form" do
      get :login

      response.should be_success
      response.should render_template("users/login")
      flash[:notice].should == "Please login"
    end

    it "should redirect after successful login" do
      post :login, :user => { :username => 'calvin', :password => 'calvinpassword' }

      response.should redirect_to(administrate_path)
      flash.should be_empty
      session[:current_user_id].should_not be_nil
    end

    it "should show the form when login is bad" do
      post :login, :user => { :username => 'calvin', :password => 'BAD PASSWORD' }
      
      response.should be_success
      response.should render_template("users/login")
      session[:current_user_id].should be_nil
    end
  end

  describe "logging out" do
    it "should log out and redirect to homepage" do
      get :logout, {}, user_session(:edit)

      response.should redirect_to(root_path)
      session[:current_user_id].should be_nil
    end
  end

  describe "getting list" do
    it "should have a list of users" do
      
    end
  end
end
