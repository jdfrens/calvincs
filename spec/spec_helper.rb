# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)
require 'spec/autorun'
require 'spec/rails'

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

  # == Fixtures
  #
  # You can declare fixtures for each example_group like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so right here. Just uncomment the next line and replace the fixture
  # names with your fixtures.
  #
  # config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
  #
  # You can also declare which fixtures to use (for example fixtures for test/fixtures):
  #
  # config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  #
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  #
  # == Notes
  # 
  # For more information take a look at Spec::Runner::Configuration and Spec::Runner
end

# TODO: can this be phased out?
def assert_equal_set(expected, actual, message=nil)
  assert_equal expected.to_set, actual.to_set, message
end

# TODO: can this be phased out?
def assert_invalid(object, invalids, valids=[])
  assert !object.valid?, "#{object} should not be valid"
  invalids.each do |invalid|
    assert object.errors.invalid?(invalid), "#{invalid} should not be valid, but it is"
  end
  valids.each do |valid|
    assert !object.errors.invalid?(valid), "#{valid} should be valid, but it's not"
  end
end

# TODO: get rid of this!
def assert_standard_layout(options = {})
  options = { :title => nil, :last_updated => false }.merge(options)

  if options[:title]
    raise "use: assigns[:title].should == '#{options[:title]}'"
  end
  if options[:last_updated]
    raise "use: assigns[:last_updated].should == '#{options[:last_updated]}'"
  end
  raise "stop using me!"
end

def user_session(privilege)
  case privilege
  when :edit
    { :current_user_id => users(:jeremy).id }
  else
    raise "#{privilege.to_s} is an unrecognized privilege"
  end
end

def mock_user_session(privilege)
	case privilege
  when :edit
    editor = mock_model(User)
    User.stub!(:find).with(editor.id, anything()).and_return(editor)
    editor.stub!(:has_privilege?).with(:edit).and_return(true)
    { :current_user_id => editor.id }
  else
    raise "#{privilege.to_s} is an unrecognized privilege"
  end
end

def user_fixtures
	fixtures :users, :groups, :privileges, :groups_privileges
end

def expect_textilize_wop(text)
  template.should_receive(:textilize_without_paragraph).with(text).
    and_return(text)
end

def expect_textilize(text)
  template.should_receive(:textilize).with(text).and_return(text)
end

# TODO: better RSpec way to do this?
def assert_datetime_selector(model, attribute)
  assert_select "select##{model}_#{attribute}_1i", 1, "should have a year selector"
  assert_select "select##{model}_#{attribute}_2i", 1, "should have a month selector"
  assert_select "select##{model}_#{attribute}_3i", 1, "should have a day selector"
  assert_select "select##{model}_#{attribute}_4i", 1, "should have a hour selector"
  assert_select "select##{model}_#{attribute}_5i", 1, "should have a minute selector"
end

# TODO: replace with RSpec matcher
def assert_spinner(options = {})
  id_suffix = options[:number] || options[:suffix]
  id = id_suffix ? "spinner_#{id_suffix}" : "spinner"
  assert_select "img##{id}[src^=/images/spinner_moz.gif]"
end

# TODO: replace with RSpec matcher
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
