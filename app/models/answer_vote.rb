class AnswerVote < ActiveRecord::Base
  class Kind
    VOTE_UP     = 'VOTE_UP'
    VOTE_DOWN   = 'VOTE_DOWN'
    VOTE_CANCEL = 'VOTE_CANCEL'
  end

  attr_accessible :answer, :kind, :user

  belongs_to :user
  belongs_to :answer

  validates :user, :answer, :kind, :presence => true
  validates_uniqueness_of :answer_id, :scope => :user_id,
                                      :message => "每个回答只允许投票一次"
  validates_inclusion_of :kind, :in => [
    Kind::VOTE_UP, Kind::VOTE_DOWN, Kind::VOTE_CANCEL
  ]

  scope :by_user, lambda { |user| where(:user_id => user.id) }

  after_save :update_vote_sum
  after_destroy :update_vote_sum
  def update_vote_sum
    self.answer.refresh_vote_sum!
    self._clean_feeds
  end

  # Issue #31
  def _clean_feeds
    return if self.kind == Kind::VOTE_UP
    MindpinFeeds::Feed.to(self).destroy_all
  end

  # 记录用户活动
  record_feed :scene => :questions,
                        :callbacks => [ :create, :update ]
  def creator; self.user; end # 供 feed 组件调用

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
