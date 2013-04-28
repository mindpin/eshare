class RedisValueCacheBaseProxy
  def value_db
    raise '需要实现 value_db'
  end

  def value
    cache = RedisValueCache.new(@key)
    if !cache.exists
      refresh_cache
    end
    cache.value
  end

  def refresh_cache
    raise('cache key 未定义') if @key.nil?
    RedisValueCache.new(@key).set_value(value_db)
  end

  def delete_cache
    raise('cache key 未定义') if @key.nil?
    RedisValueCache.new(@key).delete
  end
end