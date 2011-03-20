role :web, "yags.calvin.edu"
role :app, "yags.calvin.edu"
role :db, "yags.calvin.edu", :primary => true

set :branch, "staging"

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
