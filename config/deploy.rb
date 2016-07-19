# order of deployment for production servers:
# 1) deploy 2nd server with assets:precompile, and prepare assets.tar.gz
# 2) deploy 1nd and 3-rd servers without precompiling - only copy assets dir from 2nd server
# other servers - deploy without any changes - will precompile templates for all servers, using turbo-sprockets
#require File.join(File.expand_path(File.dirname(__FILE__)),'..','lib/capistrano-db-tasks/lib/dbtasks')

#require 'airbrake/capistrano'
require 'rvm/capistrano'
require 'bundler/capistrano'

set :rvm_ruby_string, 'ruby-2.0.0-p643'
set :rvm_type, :user
# set :rvm_type, :deploy
# set :rvm_type, :system
# set :rvm_bin_path, "/home/deploy/.rvm/bin"

set :application, 'todolist'
set :scm        , :git
set :repository , 'git@github.com:mjstyle/todolist.git'
set :user       , 'deploy'
set :use_sudo   , false
set(:deploy_to)   {"/var/www/#{application}"}
set :ssh_options, {:forward_agent => true}
set :whenever_command, 'bundle exec whenever'
set :keep_releases, 5

log_formatters = [
    { :match => /RAILS_GROUPS=assets/       ,   :color => :blue,    :priority => 10, :style => :blink },
    { :match => /Copying assets from server/,   :color => :magenta, :priority => 10, :style => :blink }
]
log_formatter(log_formatters)

def deploy_prompt(env_name)
  puts "\n\e[0;31m   ######################################################################"
  puts "   #\n   #       Are you REALLY sure you want to deploy to #{env_name}?"
  puts "   #\n   #               Enter y/N + enter to continue\n   #"
  puts "   ######################################################################\e[0m\n"
  proceed = STDIN.gets[0..0] rescue nil
  exit unless proceed == 'y' || proceed == 'Y'
end

desc 'Run tasks in new production enviroment.'

task :todolist do
  deploy_prompt("TODOLIST MASTER")
  set  :rails_env ,'production'
  set  :branch    ,'master'
  set  :host      ,'50.16.139.20'
  set  :user      ,'ubuntu'
  set  :normalize_asset_timestamps, false
  role :app       ,host
  role :web       ,host
  role :db        ,host, :primary => true
  ssh_options[:keys] = ["#{ENV['HOME']}/.ssh/Notesolution-Key.pem"]
end
# bundle exec rake assets:precompile RAILS_ENV=production RAILS_GROUPS=assets

namespace :deploy do

  namespace :assets do
    task :precompile, :roles => :db do
    end
  end

  desc 'Running migrations'
  task :migrations, :roles => :db do
    run "cd #{release_path} && bundle exec rake db:migrate RAILS_ENV=#{rails_env}"
  end

  task :create_cache_folder, :roles => :db do
    run "mkdir -p #{release_path}/tmp"
    run "mkdir -p #{release_path}/tmp/cache"
    run "mkdir -p #{release_path}/tmp/cache/assets"
  end
end

namespace :nginx do
  desc 'Reload Nginx'
  task :reload do
    sudo '/etc/init.d/nginx reload'
    sudo 'touch /var/ngx_pagespeed_cache/cache.flush'
  end
end

after 'deploy:update_code' do
  run "ln -s #{shared_path}/uploads #{release_path}/uploads"
end

#before 'deploy:templates', 'deploy:assets_folder_symlink'
before  'deploy:assets:precompile', 'deploy:create_cache_folder'
after 'deploy', 'deploy:migrations'
after 'deploy:update'    , 'deploy:cleanup'
after 'deploy:migrations', 'nginx:reload'

require './config/boot'
#require 'airbrake/capistrano'
