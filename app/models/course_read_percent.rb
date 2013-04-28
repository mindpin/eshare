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
      if total_count.blank? || total_count == 0
        return has_read?(user) ? '100%' : '0%'
      end

      rc = read_count_of(user)
      p = [(rc.to_f * 100 / total_count).round, 100].min
      return "#{p}%"
    end
  end

end