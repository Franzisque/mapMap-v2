##
# deploy.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

require 'rvm/capistrano'
require 'bundler/capistrano'
set :application, 'mapmap-v2'
set :repository,  'git@git.mediacube.at:fhs34773/mapmap-v2.git'
set :deploy_to, "/var/www/#{application}"

set :scm, :git
set :branch, 'master'
set :user, 'deploy_user'
set :group, 'deploy_user'
set :use_sudo, false
set :rails_env, 'production'
set :deploy_via, :copy
set :keep_releases, 5

role :web, 'mapmap.mediacube.at:5412'
role :app, 'mapmap.mediacube.at:5412'
role :db, 'mapmap.mediacube.at:5412', primary: true

default_run_options[:pty] = true

## If you are using Passenger mod_rails uncomment this:
namespace :deploy do
    task :start do; end
    task :stop do; end
    task :restart, roles: :app, except: { no_release: true } do
        run "#{try_sudo} touch #{File.join(current_path, 'tmp', 'restart.txt')}"
    end
end

# get database.yml and secrets.yml to server
namespace :db do
    task :db_config, except: { no_release: true }, role: :app do
        run "cp -f #{shared_path}/config/database.yml #{release_path}/config/database.yml"
        run "cp -f #{shared_path}/config/secrets.yml #{release_path}/config/secrets.yml"
    end
end

# seed database
namespace :seed do
    desc 'Seed database'
    task :default do
        run "cd #{deploy_to}/current; /usr/bin/env bundle exec rake db:seed RAILS_ENV=#{rails_env}"
    end
end

after 'deploy:finalize_update', 'db:db_config'
