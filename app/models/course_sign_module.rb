module CourseSignModule
  # 2 课程模型上需要封装用户进行签到的方法
  def sign(user)
    return if todays_signs_for_user(user,Date.today).blank?
    CourseSign.create(:course_id => self.id, :user_id => user.id, :streak => sign_for_user_streak(user) )
  end

  def sign_for_user_streak(user)
    @yestarday = todays_signs_for_user(user,Date.today-1)
    return 1 if @yestarday.blank?
    @yestarday+1
  end

  def todays_signs_for_user(user,date)
    CourseSign.todays_signs_for_user(self,date,user)
  end

  # 3 课程模型上需要封装获取总签到数的查询方法
  def all_sign_count
    CourseSign.all.count
  end

  # 4 课程模型上需要封装某个用户今天是第几个签到的查询方法
  def sign_rank(user)
    @course_sign = todays_signs_for_user(user,Date.today)
    index = todays_signs.index(@course_sign)
    index && inex + 1 
  end

  def todays_signs
    CourseSign.todays_signs(self,Date.today).order('id asc')
  end

  # 5 课程模型上需要封装某个用户连续签到的天数的查询方法
  def todays_signs_for_user_streak(user)
    todays_sign = todays_signs_for_user(user,Date.today)
    return 1 if todays_sign.blank?
    todays_sign.streak
  end

  # 6 课程模型上需要封装获取当天签到人数的查询方法
  def todays_signs_count
    todays_signs.size
  end
end