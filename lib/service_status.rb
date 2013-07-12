class ServiceStatus
  ROOT_PATH = File.expand_path('../../',__FILE__)

  class << self
    def check_for_project_start
      case Rails.env
      when 'test'
        check_redis
      when 'development'
        check_redis
        check_solr
      when 'production'
        check_redis
        check_solr
        check_sidekiq
        check_faye
      end
    end

    def check_redis
      if !redis_is_run?
        raise "redis 没有启动, 可以使用 ./deploy/sh/redis_server.sh start 命令启动 redis"
      end
    end

    def check_solr
      if !solr_is_run?
        raise "solr 没有启动, 可以使用 ./deploy/sh/solr_server.sh start 命令启动 solr"
      end
    end

    def check_sidekiq
      if !sidekiq_is_run?
        raise "sidekiq 没有启动，可以使用 ./deploy/sh/sidekiq.sh start 命令启动 sidekiq"
      end
    end

    def check_faye
      if !faye_is_run?
        raise 'faye 没有启动，可以使用 ./deploy/sh/faye.sh start 命令启动 faye'
      end
    end

    ###############
    def redis_is_run?
      sh_path = File.join(ROOT_PATH, 'deploy/sh/redis_server.sh')
      _service_is_run?(sh_path)
    end

    def solr_is_run?
      sh_path = File.join(ROOT_PATH, 'deploy/sh/solr_server.sh')
      _service_is_run?(sh_path)
    end

    def sidekiq_is_run?
      sh_path = File.join(ROOT_PATH, 'deploy/sh/sidekiq.sh')
      _service_is_run?(sh_path)
    end

    def faye_is_run?
      sh_path = File.join(ROOT_PATH, 'deploy/sh/faye.sh')
      _service_is_run?(sh_path)
    end

    private
    def _service_is_run?(sh_path)
      content = `#{sh_path} status`
      content.match("not").nil? && content.match("running").present?
    end
  end
end