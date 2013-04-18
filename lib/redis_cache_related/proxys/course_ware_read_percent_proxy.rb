class CourseWareReadPercentProxy < RedisValueCacheBaseProxy
  def initialize(user, course_ware)
    @user = user
    @course_ware = course_ware
    @key = "user_#{user.id}_course_ware_#{course_ware.id}_read_percent"
  end

  def value_db
    @course_ware.read_percent_db(@user)
  end

  def self.rules
    [
      {
        :class => CourseWareReading,
        :after_save => Proc.new {|reading|
          CourseWareReadPercentProxy.new(reading.user, reading.course_ware).refresh_cache
        }
      },
      {
        :class => CourseWare,
        :after_save => Proc.new {|course_ware|
          if course_ware.total_count_changed?
            course_ware.course_ware_readings.each do |reading|
              CourseWareReadPercentProxy.new(reading.user, course_ware).delete_cache
            end
          end
        }
      }
    ]
  end

  def self.funcs
    {
      :class => CourseWare,
      :read_percent => Proc.new {|course_ware, user|
        CourseWareReadPercentProxy.new(user, course_ware).value
      }
    }
  end
end