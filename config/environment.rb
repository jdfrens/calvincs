# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.active_record.colorize_logging = false

  config.action_controller.session = {
          :session_key => '_calvincs_session',
          # for development and testing environment; production loads secret key from file
          :secret => '07d08fdeabdd5243df2d2903448a58113b4217a864ad6f379c3131a7185bba06900eea82ea16eff03917d5fca645c5a88d7cffb9f2b9fa83daea307d25b2d1c9'
  }

  # gems
  config.gem "RedCloth", :lib => 'redcloth'
  config.gem "imagesize", :lib => 'image_size'
  config.gem 'rcov'
  config.gem "chronic", :version => ">= 0.2.3"
  config.gem "factory_girl", :source => "http://gemcutter.org"
end

# time formats
Time::DATE_FORMATS[:last_updated] = "%A, %B %e, %Y"
Time::DATE_FORMATS[:news_posted] = "%B %e, %Y"
Time::DATE_FORMATS[:colloquium] = "%B %e, %Y at %l:%M %p"
Time::DATE_FORMATS[:conference] = "%B %e, %Y"
Time::DATE_FORMATS[:sitemap] = "%Y-%m-%d"

# Google Analytics
Rubaidh::GoogleAnalytics.tracker_id = 'UA-864318-1'
Rubaidh::GoogleAnalytics.domain_name = 'cs.calvin.edu'
Rubaidh::GoogleAnalytics.environments = ['production']  

CALVINCS_URL = "http://cs.calvin.edu"
