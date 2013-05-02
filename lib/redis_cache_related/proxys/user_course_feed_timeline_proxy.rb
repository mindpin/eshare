class UserCourseFeedTimelineProxy < RedisVectorArrayCacheBaseProxy
  def initialize(user)
    @user = user
    @key = "user_#{user.id}_course_feed_timeline"
  end

  def xxxs_ids_db
    @user.course_feed_timeline_db.map(&:id)
  end

  def self.rules
    [
      {
        :class => MindpinFeeds::Feed,
        :after_create => Proc.new{|feed|
          user = feed.who
          case feed.to
          when CourseWareReading
            if feed.what == "create_course_ware_reading" || feed.what == "update_course_ware_reading"
              UserCourseFeedTimelineProxy.new(user).add_to_cache(feed.id)
            end
          when Question
            if feed.to.model.is_a?(CourseWare) && feed.what == "create_question"
              UserCourseFeedTimelineProxy.new(user).add_to_cache(feed.id)
            end
          when PracticeRecord
            if feed.what == "create_practice_record"
              UserCourseFeedTimelineProxy.new(user).add_to_cache(feed.id)
            end
          end
        }
      }
    ]
  end

  def self.funcs
    {
      :class => User,
      :course_feed_timeline => Proc.new{|user|
        UserCourseFeedTimelineProxy.new(user).get_models(Feed)
      }
    }
  end
end