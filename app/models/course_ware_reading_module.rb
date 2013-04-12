module CourseWareReadingModule
  
  def sign_reading_count(user,count)
    update_reading(user,count)
  end

  # 2 课件模型需要封装"被一个用户标记为已读"的方法
  def sign_reading(user)
    update_reading(user,nil)
  end
  # 2 课件模型需要封装"被一个用户标记为未读"的方法
  def sign_no_reading(user)
    sign_no_reading_update(user)
  end


  def update_reading(user,count)
    reading = get_readed_by_user(user)
    if reading.blank?
      sign_reading_create(user,true,count)
    else
      sign_reading_update(reading,true,count)
    end
  end

  def sign_reading_create(user,read,count)
    return if sign_read_count(read,count).blank?
    self.course_ware_readings.create(:user => user, :read => sign_read_count(read,count), :read_count => count)
  end

  def sign_reading_update(reading,read,count)
    sign_read = sign_read_count(read,count)
    return if sign_read.blank?
    reading_update(reading,count,sign_read)
  end

  def sign_no_reading_update(user)
    reading = get_readed_by_user(user)
    count = self.total_count.blank? ? nil:0
    reading_update(reading,count,false)
  end

  def reading_update(reading,count,read)
    return if reading.blank?
    reading.read_count = count
    reading.read = read
    reading.save
  end

  def sign_read_count(read,count)
    return read if self.total_count.blank?
    return count == self.total_count
    return nil if  count > self.total_count
  end

  def get_readed_by_user(user)
    reading = self.course_ware_readings.by_user(user).first
    reading
  end

  # 3 课件模型需要封装"查询一个用户是否已读过"的方法
  def has_read?(user)
    !get_readed_by_user(user).blank? && (get_readed_by_user(user).read == true)
  end

  # 4 课件模型需要封装"查询被读过的总数"的方法
  def readed_count
    self.course_ware_readings.by_read(true).count
  end
end