desc "Load fixtures data into the development database"
task :load_fixtures_data_to_development do
   require 'active_record/fixtures'
   RAILS_ENV = 'development'
   require File.dirname(__FILE__) + '/../../config/environment'
   ActiveRecord::Base.establish_connection()
   Fixtures.create_fixtures("spec/fixtures", %w(events newsitems))
end
