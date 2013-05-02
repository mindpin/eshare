module CourseReadPercent
  
  module CourseMethods
    # 获取课程的学习进度
    # 不保留小数位
    def read_percent_db(user)
      cws_count = course_wares.count
      return '0%' if cws_count == 0

      sum = course_wares.sum { |c| c.read_percent_db(user).to_f }
      p = (sum / cws_count).round
      return "#{p}%"
    end
  end

  module ChapterMethods
    # 获取章节的学习进度
    def read_percent_db(user)
      cws_count = course_wares.count
      return '0%' if cws_count == 0

      sum = course_wares.sum { |c| c.read_percent_db(user).to_f }
      p = (sum / cws_count).round
      return "#{p}%"
    end
  end

  module CourseWareMethods
    # 获取课件的学习进度
    def read_percent_db(user)
      cw = course_ware_readings.by_user(user).first
      return '0%' if cw.blank?
      return cw.read_percent
    end
  end

end