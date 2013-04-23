module CourseReadPercent
  
  module CourseMethods
    # 获取课程的学习进度
    def read_percent_db(user)
      return 0 if chapters.count == 0

      sum = 0
      count = 0
      chapters.each do |ch|
        sum += ch.read_percent_db(user).to_f
        count += 1
      end

      p = (sum / count).round
      return "#{p}%"
    end
  end

  module ChapterMethods
    # 获取章节的学习进度
    def read_percent_db(user)
      return 0 if course_wares.count == 0
      
      sum = 0
      count = 0
      course_wares.each do |cw|
        sum += cw.read_percent_db(user).to_f
        count += 1
      end

      p = (sum / count).round
      return "#{p}%"
    end
  end

  module CourseWareMethods
    # 获取课件的学习进度
    def read_percent_db(user)
      if total_count.blank? || total_count == 0
        return '100%' if has_read?(user)
        return '0%'
      end

      p = read_count_of(user)
      return "#{(p.to_f * 100 / total_count).round}%"
    end
  end

end