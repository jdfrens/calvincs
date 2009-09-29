default_run_options[:pty] = true

set :application, "calvincs"

set :scm, "git"
set :repository,  "git://github.com/jdfrens/calvincs.git"
set :branch, "master"
# set :scm_passphrase, "p@ssw0rd" #This is your custom users password
set :user, "calvincs"
set :runner, "calvincs"

# If you have previously been relying upon the code to start, stop 
# and restart your mongrel application, or if you rely on the database
# migration code, please uncomment the lines you require below

# If you are deploying a rails app you probably need these:

#load 'ext/rails-database-migrations.rb'
#load 'ext/rails-shared-directories.rb'

# There are also new utility libaries shipped with the core these 
# include the following, please see individual files for more
# documentation, or run `cap -vT` with the following lines commented
# out to see what they make available.

# load 'ext/spinner.rb'              # Designed for use with script/spin
# load 'ext/passenger-mod-rails.rb'  # Restart task for use with mod_rails
# load 'ext/web-disable-enable.rb'   # Gives you web:disable and web:enable

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/srv/www/#{application}"

set :gateway, "jdfrens@cs-ssh.calvin.edu"

role :web, "yags.calvin.edu"
role :app, "yags.calvin.edu"
role :db, "yags.calvin.edu", :primary => true

task :after_update_code, :roles => :app, :except => {:no_symlink => true} do
  run <<-CMD
    cd #{release_path} && ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml && ln -nfs #{shared_path}/config/mongrel_cluster.yml #{release_path}/config/mongrel_cluster.yml
  CMD
end
