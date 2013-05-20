module UserFeedStream
  def self.included(base)
    base.send :include, InstanceMethods
  end

  module InstanceMethods
    def homeline_db
      MindpinFeeds::Feed.by_user(self).order('id desc')
    end

    def timeline_db
      MindpinFeeds::Feed.find_by_sql(%`
        SELECT feeds.* FROM feeds
        inner join 
        (
          SELECT
            follows.following_user_id as id
          FROM
            follows
          WHERE follows.user_id = #{self.id}

          UNION

          SELECT #{self.id} as id
        ) as fus
        on fus.id = feeds.user_id

        order by feeds.id desc
      `
      )
    end
  end
end
