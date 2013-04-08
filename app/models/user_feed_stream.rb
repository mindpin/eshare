module UserFeedStream
  def self.included(base)
    base.send :include, InstanceMethods
  end

  module InstanceMethods
    def homeline
      MindpinFeeds::Feed.by_user(self).order('id desc')
    end

    def timeline
      MindpinFeeds::Feed.where(:user_id => self.following_ids + [self.id]).order('id desc')
    end
  end
end
