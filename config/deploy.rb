require 'mina/bundler'
require 'mina/rails'
require 'mina/git'

set :domain, 'teamkn.mindpin.com'
set :deploy_to, '/web/2013/eshare'
set :current_path, 'current'
set :repository, 'git://github.com/mindpin/eshare.git'
set :branch, 'master'
set :user, 'root'

set :shared_paths, [
  'config/survey_templates',
  'config/database.yml',
  'db/schema.rb',
  'log', 
  'tmp/pids',
  '.ruby-version', 
  'deploy/sh/property.yaml', 
  'public/YKAuth.txt', 
  'public/project_key',
  'config/oauth_key.yaml',
  'config/initializers/r.rb']

task :environment do
end

task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/config/initializers"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]
  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue! %[touch "#{deploy_to}/shared/config/oauth_key.yaml"]
  queue! %[touch "#{deploy_to}/shared/config/initializers/r.rb"]

  queue! %[mkdir -p "#{deploy_to}/shared/config/survey_templates"]

  queue! %[mkdir -p "#{deploy_to}/shared/db"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/db"]
  queue! %[touch "#{deploy_to}/shared/db/schema.rb"]

  queue! %[mkdir -p "#{deploy_to}/shared/deploy/sh"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/deploy/sh"]
  queue! %[touch "#{deploy_to}/shared/deploy/sh/property.yaml"]

  queue! %[mkdir -p "#{deploy_to}/shared/public/project_key"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/public"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/public/project_key"]
  queue! %[touch "#{deploy_to}/shared/public/YKAuth.txt"]

  queue! %[touch "#{deploy_to}/shared/.ruby-version"]

  queue! %[mkdir -p "#{deploy_to}/shared/tmp/pids"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/pids"]

  queue  %[echo "-----> Be sure to edit 'shared/config/database.yml'."]
  queue  %[echo "-----> Be sure to edit 'shared/config/oauth_key.yaml'."]
  queue  %[echo "-----> Be sure to edit 'shared/db/schema.rb'."]
  queue  %[echo "-----> Be sure to edit 'shared/config/initializers/r.rb'."]
  queue  %[echo "-----> Be sure to edit 'shared/.ruby-version'."]
  queue  %[echo "-----> Be sure to edit 'shared/deploy/sh/property.yaml'."]
  queue  %[echo "-----> Be sure to edit 'shared/public/YKAuth.txt'."]
end

desc "init_verify_key"
task :init_verify_key => :environment do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    queue! "bundle"
    queue! "ruby script/init_verify_key.rb"
  end
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    queue! "bundle"
    # invoke :'bundle:install'
    # invoke :'rails:db_migrate'
    queue! "rake db:create RAILS_ENV=production"
    queue! "rake db:migrate RAILS_ENV=production"
    invoke :'rails:assets_precompile'

    to :launch do
      queue %[
        source /etc/profile
        ./deploy/sh/redis_server.sh restart
        ./deploy/sh/sidekiq.sh restart
        ./deploy/sh/unicorn_eshare.sh stop
        ./deploy/sh/unicorn_eshare.sh start
        ./deploy/sh/solr_server.sh stop
        ./deploy/sh/solr_server.sh start
        bundle exec thin restart -f -C config/thin.yml -R faye.ru
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
    ./deploy/sh/solr_server.sh stop
    ./deploy/sh/solr_server.sh start
    bundle exec thin restart -f -C config/thin.yml -R faye.ru
  ]
end
# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers

