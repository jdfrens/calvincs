role :web, "cerf.calvin.edu"
role :app, "cerf.calvin.edu"
role :db, "cerf.calvin.edu", :primary => true

set :branch, "deploy"

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end
