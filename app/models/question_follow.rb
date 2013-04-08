class QuestionFollow < ActiveRecord::Base
  attr_accessible :user, :question, :last_view_time

  belongs_to :user
  belongs_to :question

  validates :user, :question, :last_view_time,  :presence => true

  scope :by_user, lambda { |user| where(:user_id => user.id) }

  after_save :update_last_view_time

  def update_last_view_time
    self.last_view_time = Time.now
    self.save
  end

  def follow_by_user(user)
    self.by_user(user).first
  end

  module UserMethods
    def self.included(base)
      base.has_many :question_follows

      base.send :include, InstanceMethods
    end

    module InstanceMethods
      def follow_question(question)
        QuestionFollow.create(:user => self, :question => question, :last_view_time => Time.now)
      end

      def unfollow_question(question)
        question.follow_by_user(self).destroy
      end
    end

  end


end