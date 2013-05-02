module QuestionFeedTimelime
  module UserMethods
    def question_feed_timeline_db
      MindpinFeeds::Feed.find_by_sql(%`
          SELECT feeds.* FROM feeds
          WHERE
            feeds.what = 'create_question'
          and
            feeds.user_id = #{self.id}
          and
            feeds.scene = 'questions'

        UNION

          SELECT feeds.* FROM feeds
          WHERE
            feeds.what = 'create_answer'
          and
            feeds.user_id = #{self.id}
          and
            feeds.scene = 'questions'

        UNION

          SELECT feeds.* FROM feeds
            INNER JOIN answer_votes
              ON
            feeds.to_type = 'AnswerVote'
              and
            feeds.to_id = answer_votes.id
              and
            answer_votes.kind = '#{AnswerVote::Kind::VOTE_UP}'
          WHERE
            (
              feeds.what = 'create_answer_vote'
                or
              feeds.what = 'update_answer_vote'
            )
          and
            feeds.user_id = #{self.id}
          and
            feeds.scene = 'questions'

        order by id desc
      `)
    end
  end

  module QuestionMethods
    def question_feed_timeline_db
      MindpinFeeds::Feed.find_by_sql(%`
          SELECT feeds.* FROM feeds
          WHERE
            feeds.what = 'create_question'
          and
            feeds.to_id = #{self.id}
          and
            feeds.to_type = 'Question'
          and
            feeds.scene = 'questions'

        UNION

          SELECT feeds.* FROM feeds
            INNER JOIN answers
              ON
            feeds.to_type = 'Answer'
              and
            feeds.to_id = answers.id
          WHERE
            feeds.what = 'create_answer'
          and
            answers.question_id = #{self.id}
          and
            feeds.scene = 'questions'

        UNION

          SELECT feeds.* FROM feeds
            INNER JOIN answer_votes
              ON
            feeds.to_type = 'AnswerVote'
              and
            feeds.to_id = answer_votes.id
              and
            answer_votes.kind = '#{AnswerVote::Kind::VOTE_UP}'
            INNER JOIN answers
              ON
            answers.id = answer_votes.answer_id
          WHERE
            (
              feeds.what = 'create_answer_vote'
                or
              feeds.what = 'update_answer_vote'
            )
          and
            answers.question_id = #{self.id}
          and
            feeds.scene = 'questions'

        order by id desc
      `)
    end
  end
end