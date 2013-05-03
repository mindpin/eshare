require 'mina/bundler'
require 'mina/rails'
require 'mina/git'

set :domain, ''
set :deploy_to, ''
set :current_path, 'current'
set :repository, 'git://github.com/mindpin/eshare.git'
set :branch, 'master'
set :user, 'root'

set :shared_paths, [
  'config/database.yml',
  'db/schema.rb',
  'log', 
  '.ruby-version', 
  'deploy/sh/property.yaml', 
  'public/YKAuth.txt', 
  'config/r.yaml']

task :environment do
end

task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]
  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue! %[touch "#{deploy_to}/shared/config/r.yaml"]

  queue! %[mkdir -p "#{deploy_to}/shared/db"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/db"]
  queue! %[touch "#{deploy_to}/shared/db/schema.rb"]

  queue! %[mkdir -p "#{deploy_to}/shared/deploy/sh"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/deploy/sh"]
  queue! %[touch "#{deploy_to}/shared/deploy/sh/property.yaml"]

  queue! %[mkdir -p "#{deploy_to}/shared/public"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/public"]
  queue! %[touch "#{deploy_to}/shared/public/YKAuth.txt"]  

  queue! %[touch "#{deploy_to}/shared/.ruby-version"]

  queue  %[echo "-----> Be sure to edit 'shared/config/database.yml'."]
  queue  %[echo "-----> Be sure to edit 'shared/db/schema.rb'."]
  queue  %[echo "-----> Be sure to edit 'shared/config/r.yaml'."]
  queue  %[echo "-----> Be sure to edit 'shared/.ruby-version'."]
  queue  %[echo "-----> Be sure to edit 'shared/deploy/sh/property.yaml'."]
  queue  %[echo "-----> Be sure to edit 'shared/public/YKAuth.txt'."]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    queue! "bundle"
    queue! "rake db:migrate RAILS_ENV=production"
    # invoke :'bundle:install'
    # invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'

    to :launch do
      queue %[
        source /etc/profile
        ./deploy/sh/redis_server.sh restart
        ./deploy/sh/sidekiq.sh restart
        ./deploy/sh/unicorn_eshare.sh stop
        ./deploy/sh/unicorn_eshare.sh start
      ]
    end
  end
end

desc "restart server"
task :restart => :environment do
  queue %[
    source /etc/profile
    cd #{deploy_to}/#{current_path}
    ./deploy/sh/redis_server.sh restart
    ./deploy/sh/sidekiq.sh restart
    ./deploy/sh/unicorn_eshare.sh stop
    ./deploy/sh/unicorn_eshare.sh start
  ]
end
# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers

