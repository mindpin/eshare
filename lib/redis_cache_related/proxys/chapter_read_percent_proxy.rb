class ChapterReadPercentProxy < RedisValueCacheBaseProxy
  def initialize(user, chapter)
    @user = user
    @chapter = chapter
    @key = "user_#{user.id}_chapter_#{chapter.id}_read_percent"
  end

  def value_db
    @chapter.read_percent_db(@user)
  end

  def self.rules
    [
      {
        :class => CourseWareReading,
        :after_save => Proc.new {|reading|
          chapter = reading.course_ware.chapter
          user = reading.user
          ChapterReadPercentProxy.new(user, chapter).refresh_cache
        }
      },
      {
        :class => CourseWare,
        :after_save => Proc.new {|course_ware|
          if course_ware.total_count_changed?
            chapter = course_ware.chapter

            course_ware.course_ware_readings.each do |reading|
              ChapterReadPercentProxy.new(reading.user, chapter).delete_cache
            end
          end
        }
      }
    ]
  end

  def self.funcs
    {
      :class => Chapter,
      :read_percent => Proc.new {|chapter, user|
        ChapterReadPercentProxy.new(user, chapter).value
      }
    }
  end
end