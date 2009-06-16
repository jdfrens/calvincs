# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)
require 'spec/autorun'
require 'spec/rails'
require 'webrat'

module ViewMacros
  def should_have_spinner(options = {})
    id_suffix = options[:number] || options[:suffix]
    id = id_suffix ? "spinner_#{id_suffix}" : "spinner"
    response.should have_selector("img", :id => id) do |img|
      img.first['src'].should match(%r{^/images/spinner_moz.gif})
    end
  end
end

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

  config.include Webrat::Matchers, :type => :views
  config.include ViewMacros, :type => :controller
  config.include ViewMacros, :type => :views
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
  fixtures :users, :roles, :privileges, :privileges_roles
end

def expect_textilize_wop(text)
  template.should_receive(:textilize_without_paragraph).with(text).
          and_return(text)
end

def expect_textilize(text)
  template.should_receive(:textilize).with(text).and_return(text)
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

class ImageInfo

  def self.fake_size(url, size)
    @@sizes ||= {}
    @@sizes[url] = size
  end

  def initialize(url)
    @@seen_urls ||= []
    @@seen_urls << url
    @url = url
  end

  def width
    if @@sizes[@url]
      @@sizes[@url][:width]
    else
      raise "#{@url} was unexpected"
    end
  end

  def height
    if @@sizes[@url]
      @@sizes[@url][:height]
    else
      raise "#{@url} was unexpected"
    end
  end

end