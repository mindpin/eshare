module CourseWareReadingModule
  # 2 课件模型需要封装"被一个用户标记为已读"的方法
  def sign_reading(user)
    return if has_read?(user)
    CourseWareReading.create(:user_id => user.id, :course_ware_id => self.id, :read => true )
  end

  # 3 课件模型需要封装"查询一个用户是否已读过"的方法
  def has_read?(user)
    reading = course_ware_reading_for_user(user)
    !!(reading && reading.read)
  end

  def course_ware_reading_for_user(user)
    CourseWareReading.course_ware_reading_for_user(self,user).first
  end

  # 4 课件模型需要封装"查询被读过的总数"的方法
  def readed_count
    CourseWareReading.read_for_course_ware(self).count
  end
end