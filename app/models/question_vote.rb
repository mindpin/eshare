class QuestionVote < ActiveRecord::Base
  class Kind
    VOTE_UP     = 'VOTE_UP'
    VOTE_DOWN   = 'VOTE_DOWN'
    VOTE_CANCEL = 'VOTE_CANCEL'
  end

  attr_accessible :question, :kind, :user

  belongs_to :user
  belongs_to :question

  validates :user, :question, :kind, :presence => true
  validates_uniqueness_of :answer_id, :scope => :user_id,
                                      :message => "每个问题只允许投票一次"
  validates_inclusion_of :kind, :in => [
    Kind::VOTE_UP, Kind::VOTE_DOWN, Kind::VOTE_CANCEL
  ]

  validate :not_vote_self_answer
  def not_vote_self_answer
    errors.add(:base, '不允许对自己的回答投票') if self.question.creator == self.user
  end

  scope :by_user, lambda { |user| where(:user_id => user.id) }

  after_save :update_vote_sum
  after_destroy :update_vote_sum
  def update_vote_sum
    self.question.refresh_vote_sum! if self.question.present?
    return true
  end


  def point
    return  1 if self.kind == Kind::VOTE_UP
    return -1 if self.kind == Kind::VOTE_DOWN
    return  0 if self.kind == Kind::VOTE_CANCEL
  end

  module UserMethods
    def self.included(base)
      base.has_many :question_votes
    end
  end
end
