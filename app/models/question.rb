class Question < ActiveRecord::Base
  attr_accessible :title, :content, :chapter_id, :ask_to_user_id

  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  belongs_to :ask_to, :class_name => 'User', :foreign_key => :ask_to_user_id
  belongs_to :chapter
  has_many :answers

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

  module UserMethods
    def self.included(base)
      base.has_many :questions, :foreign_key => 'creator_id'
    end
  end
end