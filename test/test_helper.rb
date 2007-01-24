ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class Test::Unit::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Add more helper methods to be used by all tests here...

  def self.should(behave,&block)
    mname = "test_should_#{behave}"
    if block
      define_method mname, &block
    else
      define_method mname do
        flunk "#{self.class.name.sub(/Test$/,'')} should #{behave}"
      end
    end
  end
  
  def assert_standard_layout
    assert_select "title" , "Computing at Calvin College"
    assert_select "link[type=text/css]"
    assert_select "script[type=text/javascript]"
    assert_select "div#accessibility" do
      assert_select "a[href=#navbar]"
      assert_select "a[href=#content]"
    end
    assert_select "div#header"
    assert_select "div#wrapper" do
      assert_select "div#content"
      assert_select "div#sidebar" do
        assert_select "div#navbar"
      end
      assert_select "div#footer-css"
    end
    if is_logged_in
      assert_select "a[href=/users/logout]", /logout/i
    else
      assert_select "a[href=/users/logout]", 0
    end
  end
  
  def assert_user_privilege(expected_id, expected_privilege)
    actual_id = session[:current_user_id]
    assert_equal expected_id, actual_id
    user = User.find(actual_id)
    assert_not_nil user, "user #{user} not found"
    privilege = Privilege.find_by_name(expected_privilege)
    assert_not_nil privilege, "privilege #{expected_privilege} not found"
    assert user.group.privileges.include?(privilege),
        "#{user.username} does not have the #{privilege.name} privilege"
  end
  
  def assert_redirected_to_login
    assert_redirected_to :controller => 'users', :action => 'login'
  end
  
  def is_logged_in
    session[:current_user_id] != nil
  end
  
end
