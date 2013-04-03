class AnswerVote < ActiveRecord::Base
  class Kind
    VOTE_UP = 'VOTE_UP'
    VOTE_DOWN = 'VOTE_DOWN'
  end

  attr_accessible :answer, :kind, :user

  belongs_to :user
  belongs_to :answer

  validates :user, :answer, :kind, :presence => true
  validates_uniqueness_of :answer_id, :scope => :user_id,
                                      :message => "每个回答只允许投票一次"

  scope :by_user, lambda { |user| where(:user_id => user.id) }

  after_save :update_vote_sum
  after_destroy :update_vote_sum
  def update_vote_sum
    self.answer.refresh_vote_sum!
  end

  def point
    return  1 if self.kind == AnswerVote::Kind::VOTE_UP
    return -1 if self.kind == AnswerVote::Kind::VOTE_DOWN
  end

  module UserMethods
    def self.included(base)
      base.has_many :answer_votes
    end
  end
end
