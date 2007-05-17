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
    
    [ "calvintemplate", "department" ].each do |filename|
      assert_select "link[type=text/css][href^=/stylesheets/#{filename}.css]",
          { :count => 1 }, "should have link to #{filename}.css stylesheet"
    end
    
    assert_select "h1#nameplate-dept", "Computer Science &amp; Information Systems"
    
    assert_select "script[type=text/javascript]"
    assert_select "div#accessibility" do
      assert_select "a[href=#navbar]"
      assert_select "a[href=#content]"
    end
    assert_select "div#header"
    assert_select "div#wrapper" do
      assert_select "div#content"
      assert_select "div#sidebar" do
        assert_select "div#navbar ul" do
          assert_select "li", 10, "ten menu items"
          assert_select "li:nth-child(1) a[href=/]", "Home"
          assert_select "li:nth-child(2) a[href=/p/about_us]", "About Us"
          assert_select "li:nth-child(3) a[href=/p/academics]", "Academics"
          assert_select "li:nth-child(4) a[href=/p/students]", "Students"
          assert_select "li:nth-child(5) a[href=/p/faculty]", "Faculty"
          assert_select "li:nth-child(6) a[href=/p/facilities]", "Facilities"
          assert_select "li:nth-child(7) a[href=/p/research]", "Research"
          assert_select "li:nth-child(8) a[href=/p/alumni]", "Alumni Profiles"
          assert_select "li:nth-child(9) a[href=/news]", "News"
          assert_select "li:nth-child(10) a[href=/p/contact_us]", "Contact Us"
        end
      end
      assert_select "div#footer-css"
    end
    if is_logged_in
      assert_select "a[href=/users/logout]", /logout/i
      assert_select "a[href=/home/administrate]", /administrate/i
    else
      assert_select "a[href=/users/logout]", 0
      assert_select "a[href=/home/administrate]", 0
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
 
  def login(username, password)
    post_via_redirect "/users/login",
       :user => { :username => username, :password => password }
    assert_response :success, 'should redirect successfully after logging in'
    assert_template 'administrate', 'should use administrate template'
    assert_equal User.find_by_username(username).id,
        session[:current_user_id], 'should have right id in session'
  end    

  def assert_redirected_to_login
    assert_redirected_to :controller => 'users', :action => 'login'
  end
  
  def is_logged_in
    session[:current_user_id] != nil
  end
  
  def user_session(privilege)
    case privilege
    when :admin
      { :current_user_id => 1 }
    else
      {}
    end
  end
  
end
