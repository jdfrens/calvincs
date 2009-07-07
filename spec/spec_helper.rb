# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)
require 'spec/autorun'
require 'spec/rails'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

  config.include Webrat::Matchers, :type => :views
  config.include ViewHelpers, :type => :controller
  config.include ViewHelpers, :type => :views
  config.extend UserMacros
  config.include UserHelpers
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