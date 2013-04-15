module CourseSignModule
  # 指定用户对当前课程签到
  def sign(user)
    return if _get_course_sign_by_user_and_date(user, Date.today).present?

    yesterday_streak = current_streak_for(user, Date.today - 1)
    self.course_signs.create :user => user,
                             :streak => yesterday_streak + 1
  end

  # 获取指定用户截至今天为止的连续签到次数
  def current_streak_for(user, date = nil)
    date ||= Date.today
    sign = _get_course_sign_by_user_and_date(user, date)
    return 0 if sign.blank?
    return sign.streak
  end

  # 获取课程的总签到数
  def signs_count
    self.course_signs.count
  end

  # 获取指定用户今天是第几个签到
  def today_sign_order_of(user)
    sign = _get_course_sign_by_user_and_date(user, Date.today)
    return nil if sign.blank?
    course_signs.on_date(Date.today).where('created_at > ?', sign.created_at).count
  end

  # 获取该课程今天的总签到记录集合
  def today_signs
    course_signs.on_date(Date.today).order('id asc')
  end

  # 获取该课程今天的总签到次数
  def today_signs_count
    today_signs.count
  end

  # 判断指定用户今天是否签到过
  def signed_today?(user)
    _get_course_sign_by_user_and_date(user, Date.today).present?
  end

  private
    def _get_course_sign_by_user_and_date(user, date)
      course_signs.of_user(user).on_date(date).first
    end
end