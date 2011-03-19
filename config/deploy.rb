require 'bundler/capistrano'
require 'capistrano/ext/multistage'

default_run_options[:pty] = true

set :application, "calvincs"

set :scm, "git"
set :repository, "git://github.com/jdfrens/calvincs.git"

set :user, "calvincs"
set :runner, "calvincs"

set :deploy_to, "/srv/www/#{application}"

set :gateway, "jdfrens@cs-ssh.calvin.edu"

after "deploy:update_code", :roles => :app, :except => {:no_symlink => true} do
  ["config/database.yml", "config/mongrel_cluster.yml", "config/newrelic.yml", "config/secret.txt"].each do |file|
    run <<-CMD
      ln -nfs #{shared_path}/#{file} #{release_path}/#{file}
    CMD
  end
end
after "deploy:update_code", "deploy:migrate"

set :mongrel_config, "/srv/www/calvincs/shared/config/mongrel_cluster.yml"
