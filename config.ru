# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

# 检查 redis solr sidekiq faye 等服务是否正常
ServiceStatus.check_for_project_start

run Eshare::Application
