role :web, "yags.calvin.edu"
role :app, "yags.calvin.edu"
role :db, "yags.calvin.edu", :primary => true

namespace :deploy do
  task :restart do
    sudo "/etc/init.d/apache2 restart"
  end
end
