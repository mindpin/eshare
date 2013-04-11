module CourseWareReadingModule
  # 2 课件模型需要封装"被一个用户标记为已读"的方法
  def sign_reading(user)
    return if has_read?(user)
    self.course_ware_readings.create(:user => user, :read => true)
  end

  # 3 课件模型需要封装"查询一个用户是否已读过"的方法
  def has_read?(user)
    reading = self.course_ware_readings.by_user(user).first
    !!(reading && reading.read)
  end

  # 4 课件模型需要封装"查询被读过的总数"的方法
  def readed_count
    self.course_ware_readings.count
  end
end