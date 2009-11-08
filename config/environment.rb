# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.active_record.colorize_logging = false

  config.action_controller.session = {
    :session_key => '_calvincs_session',
    :secret      => File.read(File.join(RAILS_ROOT, "config", "secret.txt"))
  }
  
  # gems
  config.gem "RedCloth", :lib => 'redcloth'
  config.gem "imagesize", :lib => 'image_size'
  config.gem 'rcov'
  config.gem "chronic", :version => ">= 0.2.3"
end

# time formats
Time::DATE_FORMATS[:last_updated] = "%A, %B %e, %Y"
Time::DATE_FORMATS[:news_posted] = "%B %e, %Y"
Time::DATE_FORMATS[:colloquium] = "%B %e, %Y at %l:%M %p"
Time::DATE_FORMATS[:conference] = "%B %e, %Y"

# Google Analytics
Rubaidh::GoogleAnalytics.tracker_id = 'UA-864318-1'  
Rubaidh::GoogleAnalytics.domain_name  = 'cs.calvin.edu'  
Rubaidh::GoogleAnalytics.environments = ['production']  
