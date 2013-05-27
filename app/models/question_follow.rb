class QuestionFollow < ActiveRecord::Base
  attr_accessible :user, :question, :last_view_time

  belongs_to :user
  belongs_to :question

  validates :user, :question, :last_view_time,  :presence => true
  validates :question_id, :uniqueness => {:scope => :user_id}

  scope :by_user, lambda { |user| where(:user_id => user.id) }

  module QuestionMethods
    def self.included(base)
      base.has_many :follows, :class_name => 'QuestionFollow', 
                              :foreign_key => :question_id

      base.has_many :followers, :through => :follows, 
                                   :source => :user,
                                   :order => 'question_follows.id DESC'

      base.after_create :_follow_by_creator
    end

    def follow_by_user(user)
      return if followed_by?(user)
      self.follows.create(:user => user, :last_view_time => Time.now)
    end

    def unfollow_by_user(user)
      self.follows.by_user(user).destroy_all
    end

    def followed_by?(user)
      _get_follower_by(user).present?
    end

    def visit_by!(user)
      return if !self.followed_by?(user)

      question_follow = _get_follower_by(user)

      question_follow.last_view_time = Time.now
      question_follow.save
      question_follow.reload
    end

    def last_view_time_of(user)
      return nil if !self.followed_by?(user)
      _get_follower_by(user).last_view_time
    end

    private
      def _get_follower_by(user)
        self.follows.by_user(user).first
      end

      def _follow_by_creator
        self.follow_by_user(self.creator)
      end

  end

  module UserMethods
    def self.included(base)
      base.has_many :question_follows
      base.has_many :follow_questions, :through => :question_follows, :source => :question,
        :order => 'question_follows.id desc'
    end
  end


end