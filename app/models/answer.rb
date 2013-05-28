# -*- coding: utf-8 -*-
class Answer < ActiveRecord::Base
  include AnswerCourseWare::AnswerMethods

  attr_accessible :content, :question, :creator

  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  belongs_to :question
  has_many :answer_votes, :dependent => :delete_all

  validates :creator, :question, :content, :presence => true
  validates_uniqueness_of :question_id, :scope => :creator_id,
                          :message => "只允许回复一次"

  default_scope order('vote_sum desc')

  scope :by_user, lambda { |user| where(:creator_id => user.id) }

  scope :anonymous, :conditions => ['is_anonymous = ?', true]
  scope :onymous, :conditions => ['is_anonymous = ?', false]

  # 记录用户活动
  record_feed :scene => :questions,
                        :callbacks => [ :create, :update]


  after_save :update_question_actived_at
  def update_question_actived_at 
    self.question.actived_at = Time.now

    self.question.without_feed do
      Question.record_timestamps = false
      self.question.save
      Question.record_timestamps = true
    end
  end

  def has_voted_by?(user)
    _get_answer_vote_of(user).present?
  end

  def has_voted_up_by?(user)
    return false if !has_voted_by?(user)
    return _get_answer_vote_of(user).kind == AnswerVote::Kind::VOTE_UP
  end

  def has_voted_down_by?(user)
    return false if !has_voted_by?(user)
    return _get_answer_vote_of(user).kind == AnswerVote::Kind::VOTE_DOWN
  end

  def _get_answer_vote_of(user)
    self.answer_votes.by_user(user).first
  end

  def vote_up_by!(user)
    _prepate_answer_vote(user).update_attributes :kind => AnswerVote::Kind::VOTE_UP
    reload
  end

  def vote_down_by!(user)
    _prepate_answer_vote(user).update_attributes :kind => AnswerVote::Kind::VOTE_DOWN
    reload
  end

  def vote_cancel_by!(user)
    _prepate_answer_vote(user).update_attributes :kind => AnswerVote::Kind::VOTE_CANCEL
    reload
  end

  def refresh_vote_sum!
    self.vote_sum = self.answer_votes.map(&:point).sum
    self.save
  end

  private
    def _prepate_answer_vote(user)
      self.answer_votes.by_user(user).first || self.answer_votes.build(:user => user)
    end

  module UserMethods
    def self.included(base)
      base.has_many :answers, :foreign_key => 'creator_id'
    end
  end
end
