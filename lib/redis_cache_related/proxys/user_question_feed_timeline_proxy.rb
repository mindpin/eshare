class UserQuestionFeedTimelineProxy < RedisVectorArrayCacheBaseProxy
  def initialize(user)
    @user = user
    @key  = "user_#{user.id}_question_feed_timeline"
  end

  def xxxs_ids_db
    @user.question_feed_timeline_db.map(&:id)
  end

  def self.rules
    [
      {
        :class => MindpinFeeds::Feed,
        :after_create => Proc.new{|feed|
          user = feed.who
          case feed.to
          when Question
            if feed.what == "create_question"
              UserQuestionFeedTimelineProxy.new(user).add_to_cache(feed.id)
            end
          when Answer
            if feed.what == "create_answer"
              UserQuestionFeedTimelineProxy.new(user).add_to_cache(feed.id)
            end
          when AnswerVote
            if feed.what == 'create_answer_vote' || feed.what == 'update_answer_vote'
              UserQuestionFeedTimelineProxy.new(user).add_to_cache(feed.id)
            end
          end
        },
        :after_destroy => Proc.new{|feed|
          user = feed.who
          if feed.to.is_a?(AnswerVote)
            UserQuestionFeedTimelineProxy.new(user).remove_from_cache(feed.id)
          end
        }
      }
    ]
  end

  def self.funcs
    {
      :class => User,
      :question_feed_timeline => Proc.new{|user|
        UserQuestionFeedTimelineProxy.new(user).get_models(Feed)
      }
    }
  end
end