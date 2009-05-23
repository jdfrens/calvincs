require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do

  user_fixtures

  describe "logging in" do
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
      session[:current_user_id].should_not be_nil
    end

    it "should show the form when login is bad" do
      post :login, :user => { :username => 'calvin', :password => 'BAD PASSWORD' }
      
      response.should be_success
      response.should render_template("users/login")
#      flash[:error].should == "Invalid login credentials"
      session[:current_user_id].should be_nil
    end
  end

  describe "logging out" do
    it "should log out and redirect to homepage" do
      get :logout, {}, user_session(:edit)

      response.should redirect_to(:controller => "home", :action => "index")
      session[:current_user_id].should be_nil
    end
  end

end
