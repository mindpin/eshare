class ActivityMembership < ActiveRecord::Base
  attr_accessible :activity, :user

  belongs_to :user
  belongs_to :activity, :foreign_key => :activity_id

  validates  :user,     :presence => true
  validates  :activity, :presence => true

  scope :by_activity_and_user, lambda {|activity,user| {:conditions => ['activity_id = ? AND user_id = ?',activity.id,user.id]} }

  module ActivityMethods
    def self.included(base)
      base.send :include, InstanceMethods
      base.has_many :activity_memberships
      base.has_many :members, :through => :activity_memberships, :source => :user
    end

    module InstanceMethods
      def add_member(user)
        self.activity_memberships.create :user => user if !_by_user(user)
      end

      def remove_member(user)
        self.activity_memberships.where(:user_id=>user.id).destroy_all if _by_user(user)
      end
      
      private
        def _by_user(user)
          return if user.blank?
          ActivityMembership.by_activity_and_user(self,user).first
        end
    end
  end
end