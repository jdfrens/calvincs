ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

module ERB::Util
  
  def h_original(s)
    s.to_s
  end
  
  def h(s)
    "<div class=\"h-escaped\">" + s.to_s + "</div>"
  end
  
end

module ActionView::Helpers::TextHelper

  def textilize_original(s)
    s.to_s.gsub("*", "").gsub("_", "")
  end
  
  def textilize_without_paragraph_original(s)
    s.to_s.gsub("*", "").gsub("_", "")
  end
  
  def textilize(text)
    "<div class=\"textilized\">" + text.to_s.gsub('*', '') + "</div>"
  end
  
  def textilize_without_paragraph(text)
    "<div class=\"textilized-wop\">" + 
      text.to_s.gsub('*', '') + 
      "</div>"
  end
  
end

class Test::Unit::TestCase
  
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  
  # Simple assertion methods
  
  def assert_equal_set(expected, actual, message=nil)
    assert_equal expected.to_set, actual.to_set, message
  end
  
  def assert_invalid(object, invalids, valids=[])
    assert !object.valid?, "#{object} should not be valid"
    invalids.each do |invalid|
      assert object.errors.invalid?(invalid), "#{invalid} should not be valid, but it is"
    end
    valids.each do |valid|
      assert !object.errors.invalid?(valid), "#{valid} should be valid, but it's not"
    end
  end
  
  def assert_standard_layout(options = {})
    options = { :title => nil, :last_updated => false }.merge(options)
    
    if options[:title]
      assert_select "title" , "Calvin College Computer Science - #{options[:title]}"
    else
      assert_select "title" , "Calvin College Computer Science"
    end
    
    [ "calvintemplate", "department" ].each do |filename|
      assert_select "link[type=text/css][href^=/stylesheets/#{filename}.css]",
        { :count => 1 }, "should have link to #{filename}.css stylesheet"
    end
    
    assert_select "h1#nameplate-dept a[href=/]", "Computer Science &amp; Information Systems"
    
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
          assert_select "li", 10, "should have ten menu items"
          assert_menu_item options[:menu], :home, 1, "/", "Home"
          assert_select "li:nth-child(2) a[href=/p/about_us]", "About Us"
          assert_select "li:nth-child(3) a[href=/p/academics]", "Academics"
          assert_select "li:nth-child(4) a[href=/p/students]", "Students"
          assert_menu_item options[:menu], :personnel_list, 5, "/personnel/list", "Faculty &amp; Staff"
          assert_select "li:nth-child(6) a[href=/p/facilities]", "Facilities"
          assert_select "li:nth-child(7) a[href=/p/research]", "Research"
          assert_select "li:nth-child(8) a[href=/p/alumni]", "Alumni Profiles"
          assert_menu_item options[:menu], :news, 9, "/news", "News"
          assert_select "li:nth-child(10) a[href=/p/contact_us]", "Contact Us"
        end
      end
      assert_select "div#footer-css" do
        assert_select "a[href=mailto:computing@calvin.edu]", "Computer Science Department"
        if options[:last_updated]
          assert_select "#last_updated", last_updated_text(options[:last_updated]),
            "should have last updated on #{last_updated_text(options[:last_updated])}"
        else
          assert_select "#last_updated", false, "should have no last updated"
        end
      end
    end
    if logged_in?
      assert_select "a[href=/users/logout]", /logout/i
      assert_select "a[href=/home/administrate]", /administrate/i
    else
      assert_select "a[href=/users/logout]", 0
      assert_select "a[href=/home/administrate]", 0
    end
  end

  def assert_menu_item(current, item, n, path, text)
    if current == item
      assert_select "li:nth-child(#{n}) a", false
      assert_select "li:nth-child(#{n})", text
    else
      assert_select "li:nth-child(#{n}) a[href=#{path}]", text
    end
  end
  
  def assert_datetime_selector(model, attribute)
    assert_select "select##{model}_#{attribute}_1i", 1, "should have a year selector"
    assert_select "select##{model}_#{attribute}_2i", 1, "should have a month selector"
    assert_select "select##{model}_#{attribute}_3i", 1, "should have a day selector"
    assert_select "select##{model}_#{attribute}_4i", 1, "should have a hour selector"
    assert_select "select##{model}_#{attribute}_5i", 1, "should have a minute selector"
  end
        
  def assert_spinner(options = {})
    id_suffix = options[:number] || options[:suffix]
    id = id_suffix ? "spinner_#{id_suffix}" : "spinner"
    assert_select "img##{id}[src^=/images/spinner_moz.gif]"
  end

  def assert_remote_form_for_and_spinner(id, route)
    form = find_tag :tag => "form", :attributes => { :id => id }
    assert_not_nil form, "should have form"
    assert_match(
      /Element\.show\('spinner/,
      form.attributes["onsubmit"],
      "should have JavaScript to show spinner")
    assert_match(
      /Element\.hide\('spinner/,
      form.attributes["onsubmit"],
      "should have JavaScript to hide spinner")
    assert_match(
      /Ajax\.Request\('(.+?)'/,
      form.attributes["onsubmit"],
      "should have JavaScript for Ajax request")
    form.attributes["onsubmit"] =~ /Ajax\.Request\('(.+?)'/
    assert_equal route, "#$1", "should have correct route in Ajax request"
  end

  #
  # LWT Authentication helpers
  #
  
  def self.user_fixtures
    fixtures :users, :groups, :privileges, :groups_privileges
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
    post_via_redirect "/users/login", :user => { :username => username, :password => password }
    assert_response :success, 'should redirect successfully after logging in'
    assert_template 'administrate', 'should use administrate template'
    assert_equal User.find_by_username(username).id, session[:current_user_id], 'should have right id in session'
  end    
  
  def assert_redirected_to_login
    assert_redirected_to :controller => 'users', :action => 'login'
  end
  
  def self.should_redirect_to_login_when_NOT_logged_in(action)
    should "redirect #{action} to login when NOT logged in" do
      get action
      assert_redirected_to_login
    end
  end
  
  def logged_in?
    session[:current_user_id] != nil
  end
  
  def user_session(privilege)
    case privilege
    when :edit
      { :current_user_id => users(:jeremy).id }
    else
      raise "#{privilege.to_s} is an unrecognized privilege"
    end
  end

  #
  # HTML content helpers
  #
  
  def strip_textile(string)
    string.gsub("*", "").gsub("_", "")
  end

  def assert_link_to_markup_help
    assert_select "a[href=http://hobix.com/textile/][target=_blank]",
      "Textile reference"
  end
      
  def last_updated_text(time)
    if time
      "Last updated " + time.to_s(:last_updated) + "."
    else
      time
    end
  end
  
end
