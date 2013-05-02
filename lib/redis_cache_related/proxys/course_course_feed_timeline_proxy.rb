class CourseCourseFeedTimelineProxy < RedisVectorArrayCacheBaseProxy
  def initialize(course)
    @course = course
    @key = "course_#{course.id}_course_feed_timeline"
  end

  def xxxs_ids_db
    @course.course_feed_timeline_db.map(&:id)
  end

  def self.rules
    [
      {
        :class => MindpinFeeds::Feed,
        :after_save => Proc.new{|feed|
          case feed.to
          when CourseWareReading
            if feed.what == "create_course_ware_reading" || feed.what == "update_course_ware_reading"
              course = feed.to.course_ware.chapter.course
              CourseCourseFeedTimelineProxy.new(course).add_to_cache(feed.id)
            end
          when Question
            if feed.to.model.is_a?(CourseWare) && feed.what == "create_question"
              course = feed.to.model.chapter.course
              CourseCourseFeedTimelineProxy.new(course).add_to_cache(feed.id)
            end
          when PracticeRecord
            if feed.what == "create_practice_record"
              course = feed.to.practice.chapter.course
              CourseCourseFeedTimelineProxy.new(course).add_to_cache(feed.id)
            end
          end
        }
      }
    ]
  end

  def self.funcs
    {
      :class => Course,
      :course_feed_timeline => Proc.new{|course|
        CourseCourseFeedTimelineProxy.new(course).get_models(Feed)
      }
    }
  end
end