class RedisValueCache
  attr_reader :key

  def initialize(key)
    @key = key
    @redis = RedisCache.instance
  end

  def exists
    @redis.exists(@key)
  end

  def value
    return nil if !exists
    @redis.get(@key)
  end

  def set_value(value)
    @redis.set(@key, value)
  end

  def delete
    @redis.del(@key)
  end

end
