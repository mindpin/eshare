class Question < ActiveRecord::Base
  attr_accessible :title, :content, :chapter_id, :ask_to_user_id

  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  belongs_to :ask_to, :class_name => 'User', :foreign_key => :ask_to_user_id
  belongs_to :chapter
  has_many :answers
  has_many :follows, :class_name => 'QuestionFollow', :foreign_key => :question_id

  validates :creator, :title, :content, :presence => true

  default_scope order('id desc')

  # 记录用户活动
  record_feed :scene => :questions,
                        :callbacks => [ :create, :update]

  def answered_by?(user)
    return false if user.blank?
    return self.answer_of(user).present?
  end

  def answer_of(user)
    return nil if user.blank?
    return self.answers.by_user(user).first
  end

  after_save :follow_by_creator

  def follow_by_creator
    self.follow_by_user(self.creator)
  end

  # 记录用户活动
  record_feed :scene => :questions,
                        :callbacks => [ :create, :update]

  def answered_by?(user)
    return false if user.blank?
    return self.answer_of(user).present?
  end

  def answer_of(user)
    return nil if user.blank?
    return self.answers.by_user(user).first
  end

  def follow_by_user(user)
    self.follows.create(:user => user, :question => self, :last_view_time => Time.now)
  end

  def unfollow_by_user(user)
    self.get_follower_by(user).destroy
  end


  def followed_by?(user)
    self.get_follower_by(user).present?
  end

  def get_follower_by(user)
    self.follows.by_user(user).first
  end

  def visit_by!(user)
    return if !self.followed_by?(self)

    question_follow = self.get_follower_by(self)

    question_follow.last_view_time = Time.now
    question_follow.save
    question_follow.reload
  end

  module UserMethods
    def self.included(base)
      base.has_many :questions, :foreign_key => 'creator_id'
    end
  end
end