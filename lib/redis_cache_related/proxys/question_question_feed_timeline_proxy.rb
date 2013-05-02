class QuestionQuestionFeedTimelineProxy < RedisVectorArrayCacheBaseProxy
  def initialize(question)
    @question = question
    @key = "question_#{question.id}_question_feed_timeline"
  end

  def xxxs_ids_db
    @question.question_feed_timeline_db.map(&:id)
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
              QuestionQuestionFeedTimelineProxy.new(feed.to).add_to_cache(feed.id)
            end
          when Answer
            if feed.what == "create_answer"
              QuestionQuestionFeedTimelineProxy.new(feed.to.question).add_to_cache(feed.id)
            end
          when AnswerVote
            if feed.what == 'create_answer_vote' || feed.what == 'update_answer_vote'
              question = feed.to.answer.question
              QuestionQuestionFeedTimelineProxy.new(question).add_to_cache(feed.id)
            end
          end
        },
        :after_destroy => Proc.new{|feed|
          if feed.to.is_a?(AnswerVote)
            question = feed.to.answer.question
            QuestionQuestionFeedTimelineProxy.new(question).remove_from_cache(feed.id)
          end
        }
      }
    ]
  end

  def self.funcs
    {
      :class => Question,
      :question_feed_timeline => Proc.new{|question|
        QuestionQuestionFeedTimelineProxy.new(question).get_models(Feed)
      }
    }
  end
end