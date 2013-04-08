module RedisCacheRule
  def self.included(base)
    base.after_save     :run_redis_cache_after_save
    base.after_create   :run_redis_cache_after_create
    base.after_update   :run_redis_cache_after_update
    base.after_destroy  :run_redis_cache_after_destroy

    base.alias_method_chain :method_missing, :redis_cache_rule
    base.alias_method_chain :respond_to?, :redis_cache_rule
  end

  def run_redis_cache_after_save
    run_redis_cache_by_callback_type(:after_save)
  end

  def run_redis_cache_after_create
    run_redis_cache_by_callback_type(:after_create)
  end

  def run_redis_cache_after_update
    run_redis_cache_by_callback_type(:after_update)
  end

  def run_redis_cache_after_destroy
    run_redis_cache_by_callback_type(:after_destroy)
  end

  def run_redis_cache_by_callback_type(callback_type)
    RedisCacheManagement.run_all_logic_by_rules(self, callback_type)
  rescue Exception => ex
    p ex.message
    puts ex.backtrace.join("\n")
  ensure
    return true
  end

  # -----
  
  def respond_to_with_redis_cache_rule?(method_id)
    if respond_to_without_redis_cache_rule?(method_id)
      return true
    else
      return RedisCacheManagement.has_method?(self,method_id.to_sym)
    end
  end

  def method_missing_with_redis_cache_rule(method_id, *args)
    if RedisCacheManagement.has_method?(self,method_id)
      return RedisCacheManagement.do_method(self,method_id, *args)
    else
      return method_missing_without_redis_cache_rule(method_id, *args)
    end
  end
end
