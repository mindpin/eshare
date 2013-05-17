# -*- coding: utf-8 -*-
class Follow < ActiveRecord::Base
  belongs_to :follower,
             :class_name  => 'User',
             :foreign_key => 'user_id'

  belongs_to :following,
             :class_name  => 'User',
             :foreign_key => 'following_user_id'

  validates :follower,  :presence => true 
  validates :following, :presence => true
  validate :no_follow_self
  def no_follow_self
    errors.add(:base, '不能关注自己') if self.follower == self.following
  end

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
      def follow_by_user(user)
        return if user.has_follow?(self)
        user.followings << self
      end

      def unfollow_by_user(user)
        relation = user.get_follow_relation_obj_with(self)
        return false if relation.blank?
        !!relation.first.destroy 
      end

      def has_follow?(user)
        return self.get_follow_relation_obj_with(user).present?
      end

      def get_follow_relation_obj_with(user)
        return self.forward_follows.where('following_user_id = ?', user.id)
      end
    end
  end
end
