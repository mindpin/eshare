module CourseSignModule
  # 2 课程模型上需要封装用户进行签到的方法
  def sign(user)
    return if !current_sign_for_user(user,Date.today).blank?
    CourseSign.create(:course_id => self.id, :user_id => user.id, :streak => current_streak_for(user) )
  end

  # 截至今天的连续签到天数
  def current_streak_for(user)
    @yesterday = current_sign_for_user(user,Date.today-1)
    return 1 if @yesterday.blank?
    @yesterday.streak + 1
  end

  def current_sign_for_user(user,date)
    CourseSign.current_signs_for_user(self,date,user).first
  end

  # 3 课程模型上需要封装获取总签到数的查询方法
  def signs_count
    CourseSign.where(:course_id => self.id).count
  end

  # 4 课程模型上需要封装某个用户今天是第几个签到的查询方法
  def sign_number(user)
    @course_sign = current_sign_for_user(user, Date.today)
    index = current_signs.index(@course_sign)
    index && index + 1 
  end

  def current_signs
    CourseSign.current_signs(self,Date.today).order('id asc')
  end

  # 6 课程模型上需要封装获取当天签到人数的查询方法
  def current_signs_count
    current_signs.size
  end
end