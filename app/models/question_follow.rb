class QuestionFollow < ActiveRecord::Base
  attr_accessible :user, :question, :last_view_time

  belongs_to :user
  belongs_to :question

  validates :user, :question, :last_view_time,  :presence => true
  validates_uniqueness_of :question_id, :scope => :user_id

  scope :by_user, lambda { |user| where(:user_id => user.id) }

  


  module UserMethods
    def self.included(base)
      base.has_many :question_follows

      base.send :include, InstanceMethods
    end

    module InstanceMethods
      
    end

  end


end