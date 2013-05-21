class TagFollow < ActiveRecord::Base
  belongs_to :user
  belongs_to :tag

  validates :user, :tag, :presence => true
  validates :user_id, :uniqueness => {:scope => :tag_id}

  scope :by_user, lambda {|user| {:conditions => ['tag_follows.user_id = ?', user.id]} }

  module UserMethods
    def self.included(base)
      base.has_many :tag_follows
      base.has_many :follow_tags, :through => :tag_follows, :source => :tag,
        :order => 'tag_follows.id desc'
    end
  end

  module TagMethods
    def self.included(base)
      base.has_many :tag_follows
      base.has_many :follow_users, :through => :tag_follows, :source => :user,
        :order => 'tag_follows.id desc'
    end

    def follow_by_user(user)
      return if self.is_follow?(user)
      self.follow_users << user
    end

    def unfollow_by_user(user)
      self.tag_follows.by_user(user).destroy_all
    end

    def is_follow?(user)
      self.follow_users.include?(user)
    end
  end
end
