class RedisCacheManagement
  CACHE_LOGIC      = :cache_logic

  def self.load_cache_proxy(klass)
    load_proxy(klass, CACHE_LOGIC)
  end
  
  def self.load_proxy(klass, logic_type)
    rules = klass.rules
    raise("#{klass} cache rules 未定义") if rules.nil?
    [rules].flatten.each do |r|
      @@rules[logic_type] << r
    end

    funcs = klass.funcs
    raise("#{klass} cache funcs 未定义") if funcs.nil?
    [funcs].flatten.each do |f|
      @@funcs << f
    end
  end
  
  def self.run_all_logic_by_rules(model, callback_type)
    self.run_logic_by_rules(model, CACHE_LOGIC,      callback_type)
  end

  def self.run_logic_by_rules(model, logic_type, callback_type)
    @@rules[logic_type].each do |r|
      if (r[:class] == model.class) && !r[callback_type].nil?
        r[callback_type].call(model)
      end
    end
  end

  def self.has_method?(model, method_id)
    !self.get_method(model, method_id).nil?
  end

  def self.get_method(model, method_id)
    @@funcs.each do |f|
      if (f[:class] == model.class) && !f[method_id].nil?
        return f
      end
    end
    return nil
  end

  def self.do_method(model, method_id, *args)
    func = self.get_method(model, method_id)
    func[method_id].call(model, *args)
  end
  
  @@rules = {
    CACHE_LOGIC      => []
  }

  @@funcs = []

  # 以下声明应按照一定顺序，以保证缓存回调的先后运行
  # 学习进度
  RedisCacheManagement.load_cache_proxy CourseWareReadPercentProxy
  RedisCacheManagement.load_cache_proxy ChapterReadPercentProxy
  RedisCacheManagement.load_cache_proxy CourseReadPercentProxy
  # 课程学习时间线
  RedisCacheManagement.load_cache_proxy UserCourseFeedTimelineProxy
  RedisCacheManagement.load_cache_proxy CourseCourseFeedTimelineProxy
  # 问答时间线
  RedisCacheManagement.load_cache_proxy UserQuestionFeedTimelineProxy
  RedisCacheManagement.load_cache_proxy QuestionQuestionFeedTimelineProxy
end
