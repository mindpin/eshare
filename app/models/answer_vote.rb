# -*- coding: utf-8 -*-
class AnswerVote < ActiveRecord::Base
  class Kind
    VOTE_UP     = 'VOTE_UP'
    VOTE_DOWN   = 'VOTE_DOWN'
    VOTE_CANCEL = 'VOTE_CANCEL'
  end

  include SimpleCredit::ModelMethods

  record_credit(:scene => :vote,
                :on    => [:save],
                :user  => lambda {|model| model.answer.creator},
                :delta => lambda {|model|
                  case model.kind
                  when AnswerVote::Kind::VOTE_UP     then 10
                  when AnswerVote::Kind::VOTE_DOWN   then -1
                  when AnswerVote::Kind::VOTE_CANCEL then 0
                  end
                })

  attr_accessible :answer, :kind, :user

  belongs_to :user
  belongs_to :answer

  validates :user, :answer, :kind, :presence => true
  validates_uniqueness_of :answer_id, :scope => :user_id,
                                      :message => "每个回答只允许投票一次"
  validates_inclusion_of :kind, :in => [
    Kind::VOTE_UP, Kind::VOTE_DOWN, Kind::VOTE_CANCEL
  ]

  validate :not_vote_self_answer
  def not_vote_self_answer
    errors.add(:base, '不允许对自己的回答投票') if self.answer.creator == self.user
  end

  scope :by_user, lambda { |user| where(:user_id => user.id) }

  after_save :update_vote_sum
  after_destroy :update_vote_sum
  def update_vote_sum
    self.answer.refresh_vote_sum! if self.answer.present?
    return true
  end

  # 记录用户活动
  record_feed :scene => :questions,
                        :callbacks => [ :create, :update ],
                        :before_record_feed => lambda {|answer_vote, callback_type|
                          if answer_vote.kind == Kind::VOTE_UP
                            return true
                          else
                            MindpinFeeds::Feed.to(answer_vote).destroy_all
                            return false
                          end
                        }

  def point
    return  1 if self.kind == Kind::VOTE_UP
    return -1 if self.kind == Kind::VOTE_DOWN
    return  0 if self.kind == Kind::VOTE_CANCEL
  end

  module UserMethods
    def self.included(base)
      base.has_many :answer_votes
    end
  end
end
