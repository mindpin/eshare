class Follow < ActiveRecord::Base
  belongs_to :follower,
             :class_name  => 'User',
             :foreign_key => 'user_id'

  belongs_to :following,
             :class_name  => 'User',
             :foreign_key => 'following_user_id'

  validates :follower,  :presence => true 
  validates :following, :presence => true

  module UserMethods
    def self.included(base)
      base.send :include, InstanceMethods

      base.has_many :forward_follows,
                    :class_name  => 'Follow',
                    :foreign_key => 'user_id'
      base.has_many :followings,
                    :source  => 'following',
                    :through => :forward_follows

      base.has_many :backward_follows,
                    :class_name  => 'Follow',
                    :foreign_key => 'following_user_id'
      base.has_many :followers,
                    :source  => 'follower',
                    :through => :backward_follows
    end

    module InstanceMethods
      def follow(user)
        self.followings << user
      end

      def unfollow(user)
        relation = self.forward_follows.where('following_user_id = ?', user.id)
        return false if relation.blank?
        !!relation.first.destroy 
      end
    end
  end
end
