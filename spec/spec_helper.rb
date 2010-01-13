# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path(File.join(File.dirname(__FILE__),'..','config','environment'))
require 'spec/autorun'
require 'spec/rails'

# Uncomment the next line to use webrat's matchers
require 'webrat/integrations/rspec-rails'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

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
