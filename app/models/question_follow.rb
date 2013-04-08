class QuestionFollow < ActiveRecord::Base
  attr_accessible :user, :question, :last_view_time

  belongs_to :user
  belongs_to :question

  validates :user, :question, :last_view_time,  :presence => true



  module UserMethods
    def self.included(base)
      base.has_many :question_follows
    end
  end
end