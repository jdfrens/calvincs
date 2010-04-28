role :web, "cerf"
role :app, "cerf"
role :db, "cerf", :primary => true

namespace :deploy do
  task :restart do
    sudo "mongrel_rails cluster::restart -C #{mongrel_config}"
  end
end
