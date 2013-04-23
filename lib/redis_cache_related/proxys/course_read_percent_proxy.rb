class CourseReadPercentProxy < RedisValueCacheBaseProxy
  def initialize(user, course)
    @user = user
    @course = course
    @key = "user_#{user.id}_course_#{course.id}_read_percent"
  end

  def value_db
    @course.read_percent_db(@user)
  end

  def self.rules
    [
      {
        :class => CourseWareReading,
        :after_save => Proc.new {|reading|
          course = reading.course_ware.chapter.course
          user = reading.user
          CourseReadPercentProxy.new(user, course).refresh_cache
        }
      },
      {
        :class => CourseWare,
        :after_save => Proc.new {|course_ware|
          if course_ware.total_count_changed?
            course = course_ware.chapter.course

            course_ware.course_ware_readings.each do |reading|
              CourseReadPercentProxy.new(reading.user, course).delete_cache
            end
          end
        }
      }
    ]
  end

  def self.funcs
    {
      :class => Course,
      :read_percent => Proc.new {|course, user|
        CourseReadPercentProxy.new(user, course).value
      }
    }
  end
end