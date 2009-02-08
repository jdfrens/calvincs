require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class UsersControllerTest < Test::Unit::TestCase
  
  fixtures :users
  
  def setup
    @controller = UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_login
    get :login

    assert_response :success
    assert flash.empty?
    assert_login_form
  end
  
  def test_login
    post :login, :user => { :username => 'calvin', :password => 'calvinpassword' }

    assert_redirected_to :controller => 'home', :action => 'administrate'
    assert flash.empty?

    post :login, :user => { :username => 'joel', :password => 'joelpassword' }

    assert_redirected_to :controller => 'home', :action => 'administrate'
    assert flash.empty?
  end
    
  def test_login_failure
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
