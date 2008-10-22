# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.1.1' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Add additional load paths for your own custom dirs
  config.load_paths += %W(
      #{RAILS_ROOT}/vendor/RedCloth-3.0.4/lib
      #{RAILS_ROOT}/vendor/imagesize-0.1.1/lib
  )

  config.active_record.colorize_logging = false

  config.action_controller.session = {
    :session_key => '_calvincs_session',
    :secret      => '8592658a59e6ea19cd9b20cf63373e3f63959d719cb7ec219116cda15f79d46fffd13bce4d9e53d25e4ce5f6070b382283b1e
ab42f1f26f41a724f67ac07538d'
  }

  # gems
  # TODO: add version numbers when possible
  config.gem "thoughtbot-shoulda", :lib => "shoulda/rails", :source => "http://gems.github.com"
#  config.gem "RedCloth" # , :version => '4.0.3'
  #  rake gems:install
  #  rake gems:unpack
end

# time formats
Time::DATE_FORMATS[:last_updated] = "%A, %B %e, %Y"
Time::DATE_FORMATS[:news_posted] = "%B %e, %Y"
Time::DATE_FORMATS[:colloquium] = "%B %e, %Y at %r"

# Google Analytics
Rubaidh::GoogleAnalytics.tracker_id = 'UA-864318-1'  
Rubaidh::GoogleAnalytics.domain_name  = 'cs.calvin.edu'  
Rubaidh::GoogleAnalytics.environments = ['production']  