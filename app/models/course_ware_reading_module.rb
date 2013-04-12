module CourseWareReadingModule

  # 标记指定的 user 对课件的阅读状态为 已读
  def set_read_by!(user)
    reading = _prepare_reading_of(user)
    reading.update_attributes :read => true
  end

  # 标记指定的 user 对于课件的阅读状态为 未读
  # 同时将 read_count 值清零
  def set_unread_by!(user)
    reading = _prepare_reading_of(user)
    reading.update_attributes :read => false, :read_count => 0
  end

  # 更新指定用户的已读值
  # 如果 total_count 有值，且 read_count == total_count
  # 则设置为已读
  def update_read_count_of(user, read_count)
    reading = _prepare_reading_of(user)
    reading.read_count = read_count
    reading.read = true if total_count && read_count >= total_count
    reading.save
  end

  # 查询指定 user 是否已经读过这个课件
  def has_read?(user)
    _prepare_reading_of(user).read?
  end

  # 统计已经读过这个课件的人数
  def readed_users_count
    self.course_ware_readings.by_read(true).count
  end

  # 尝试返回某个user的已读值
  def read_count_of(user)
    _prepare_reading_of(user).read_count || 0
  end

  private
    # 查找，或者构造一个reading记录
    def _prepare_reading_of(user)
      self.course_ware_readings.by_user(user).first || self.course_ware_readings.build(:user => user)
    end
end