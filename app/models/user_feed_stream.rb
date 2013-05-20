module UserFeedStream
  def self.included(base)
    base.send :include, InstanceMethods
  end

  module InstanceMethods
    def user_timeline(opts = {})
      since_id = opts[:since_id]
      max_id   = opts[:max_id]
      count    = opts[:count] || 20
      page     = opts[:page] || 1

      where = _make_where_for_since_and_max_id(since_id, max_id)
      limit = count
      offset = count * (page - 1)

      MindpinFeeds::Feed.by_user(self).order('id desc').limit(limit).offset(offset).where(where)
    end

    def home_timeline(opts = {})
      since_id = opts[:since_id]
      max_id   = opts[:max_id]
      count    = opts[:count] || 20
      page     = opts[:page] || 1

      where = _make_where_for_since_and_max_id(since_id, max_id)
      limit = count
      offset = count * (page - 1)

      MindpinFeeds::Feed.find_by_sql %~
        SELECT feeds.* 
        FROM feeds
        INNER JOIN 
        (
          SELECT follows.following_user_id AS ID
          FROM follows
          WHERE follows.user_id = #{self.id}

          UNION

          SELECT #{self.id} AS ID
        ) AS FUS
        ON FUS.ID = feeds.user_id
        WHERE #{where}
        ORDER BY feeds.id desc
        LIMIT #{limit}
        OFFSET #{offset}
      ~
    end

    def _make_where_for_since_and_max_id(since_id, max_id)
      return 'TRUE' if since_id.blank? && max_id.blank?
      return "feeds.id > #{since_id}" if max_id.blank?
      return "feeds.id <= #{max_id}" if since_id.blank?
      return "feeds.id > #{since_id} AND feeds.id <= #{max_id}"
    end
  end
end
