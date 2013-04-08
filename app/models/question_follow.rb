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
      def follow_question(question)
        QuestionFollow.create(:user => self, :question => question, :last_view_time => Time.now)
      end

      def unfollow_question(question)
        question.follow_by_user(self).destroy
      end

      def visit_question(question)
        return if !question.followed_by?(self)
        
        question_follow = question.follow_by_user(self)

        question_follow.last_view_time = Time.now
        question_follow.save
        question_follow.reload
      end
    end

  end


end