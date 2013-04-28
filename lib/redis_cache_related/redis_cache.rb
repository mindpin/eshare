class RedisCache
  if Rails.env.test?
    CACHE_DB = 3
  else
    CACHE_DB = 2
  end

  def self.instance
    @@instance ||= self.get_db_instance(CACHE_DB)
  end

  # 清空当前 readis 数据库
  def self.flushdb
    self.instance.flushdb
  end

  def self.get_db_instance(db)
    redis = Redis.new(:thread_safe=>true)
    redis.select(db)
    redis
  end
end
