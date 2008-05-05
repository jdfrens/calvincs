# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.0.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence those specified here
  
  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Add additional load paths for your own custom dirs
  config.load_paths += %W(
      #{RAILS_ROOT}/vendor/RedCloth-3.0.4/lib
      #{RAILS_ROOT}/vendor/imagesize-0.1.1/lib
      )

  # Force all environments to use the same logger level 
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug
  config.active_record.colorize_logging = false

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_calvincs_session',
    :secret      => '8592658a59e6ea19cd9b20cf63373e3f63959d719cb7ec219116cda15f79d46fffd13bce4d9e53d25e4ce5f6070b382283b1e
ab42f1f26f41a724f67ac07538d'
  }

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper, 
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
  
  # See Rails::Configuration for more options
end

# Add new inflection rules using the following format 
# (all these examples are active by default):
# Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# Include your application configuration below

# time formats
Time::DATE_FORMATS[:last_updated] = "%A, %B %e, %Y"
Time::DATE_FORMATS[:news_posted] = "%B %e, %Y"
Time::DATE_FORMATS[:colloquium] = "%B %e, %Y at %r"

# Google Analytics
Rubaidh::GoogleAnalytics.tracker_id = 'UA-864318-1'  
Rubaidh::GoogleAnalytics.domain_name  = 'cs.calvin.edu'  
Rubaidh::GoogleAnalytics.environments = ['production']  