role :web, "yags.calvin.edu"
role :app, "yags.calvin.edu"
role :db, "yags.calvin.edu", :primary => true

set :branch, "staging"

namespace :deploy do
  task :restart do
    # sudo "/etc/init.d/apache2 restart"
    run "cd #{deploy_to}/current ; #{sudo} bundle exec mongrel_rails cluster::restart -C #{mongrel_config}"
  end
end
