# -*- coding: utf-8 -*-
require "redis"
require "redis-namespace"
require "redis-search"

redis = Redis.new(:host => "127.0.0.1",:port => "6379")
redis.select(3)

redis = Redis::Namespace.new("edushare:redis_search", :redis => redis)
Redis::Search.configure do |config|
  config.redis = redis
  config.complete_max_length = 100
  config.pinyin_match = true
  # 是否开启中文分词，true为关闭，可节省内存占用
  config.disable_rmmseg = true
end
