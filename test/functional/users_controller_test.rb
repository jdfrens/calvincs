require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < Test::Unit::TestCase
  
  fixtures :users
  
  def setup
    @controller = UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  should "get log-in page" do
    get :login

    assert_response :success
    assert flash.empty?
    assert_login_form
  end
  
  should "be able to log in" do
    post :login, :user => { :username => 'calvin', :password => 'john' }

    assert_redirected_to :controller => 'home', :action => 'administrate'
    assert flash.empty?
  end
    
  should "fail to log in" do
    post :login, :user => { :username => 'calvin', :password => 'BAD PASSWORD' }

    assert_response :success
    assert_select "p#error", "Invalid login credentials"
    assert_login_form
  end
  
  #
  # Helpers
  #
  private
  
  def assert_login_form
    assert_select "h1", "Log In"
    assert_select "input#user_username[type=text]"
    assert_select "input#user_password[type=password]"
    assert_select "input[type=submit]"
  end
    
end
