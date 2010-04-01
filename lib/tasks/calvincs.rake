require 'spec/rake/spectask'

namespace :calvincs do
  desc "sets up system after checked out"
  task :setup do
    sh "cp #{RAILS_ROOT}/config/database.example #{RAILS_ROOT}/config/database.yml"
    sh "cp #{RAILS_ROOT}/config/newrelic.example.yml #{RAILS_ROOT}/config/newrelic.yml"
    Rake::Task["calvincs:setup:migrate"].invoke
    Rake::Task["calvincs:users:defaults"].invoke
  end

  namespace :setup do
    task :migrate => ["db:migrate"]
  end

  desc "Runs the redirection and rewrite expectations for cs.calvin.edu"
  Spec::Rake::SpecTask.new(:redirects) do |t|
    t.spec_files = FileList['deployment/*_spec.rb']
  end

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
