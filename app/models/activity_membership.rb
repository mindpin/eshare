class ActivityMembership < ActiveRecord::Base
  attr_accessible :activity, :user

  belongs_to :user
  belongs_to :activity, :foreign_key => :activity_id

  validates  :user,     :presence => true
  validates  :activity, :presence => true



  module ActivityMethods
    def self.included(base)
      base.send :include, InstanceMethods
      base.has_many :activity_memberships
      base.has_many :members, :through => :activity_memberships, :source => :user
    end

    module InstanceMethods
      def add_member(user)
        self.activity_memberships.create :user => user
      end

      def remove_member(user)
        self.activity_memberships.where(:user_id=>user.id).destroy_all
      end
    end
  end
end