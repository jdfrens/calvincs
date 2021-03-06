# require 'rspec/core/rake_task'

# task :spec => "spec:javascripts"

namespace :calvincs do
  desc "sets up system after checked out"
  task :setup do
    sh "cp #{Rails.root}/config/database.example #{Rails.root}/config/database.yml"
    sh "cp #{Rails.root}/config/newrelic.example.yml #{Rails.root}/config/newrelic.yml"
    Rake::Task["calvincs:setup:migrate"].invoke
    Rake::Task["calvincs:users:defaults"].invoke
  end

  namespace :setup do
    task :migrate => ["db:migrate"]
  end

  # desc "Runs the redirection and rewrite expectations for cs.calvin.edu"
  # RSpec::Core::RakeTask.new(:redirects) do |t|
  #   t.pattern = 'deployment/*_spec.rb'
  # end

  namespace :users do
    desc "activate all users"
    task :activate => :environment do
      User.activate_users
    end

    desc "creates defaults in database"
    task :defaults => :environment do
      User.defaults
      Role.all.each do |role|
        puts "Role #{role.name} exists."
      end
    end
  end
end
