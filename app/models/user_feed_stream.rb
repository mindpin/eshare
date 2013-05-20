module UserFeedStream
  def self.included(base)
    base.send :include, InstanceMethods
  end

  module InstanceMethods
    def homeline
      MindpinFeeds::Feed.by_user(self).order('id desc')
    end

    def timeline
      MindpinFeeds::Feed.find_by_sql(%`
        SELECT feeds.* FROM feeds
        WHERE feeds.user_id IN (
          SELECT
            follows.following_user_id
          FROM
            follows
          WHERE follows.user_id = #{self.id}

          UNION

          SELECT #{self.id}
        )
      `
      )
    end
  end
end
