class AnswerVote < ActiveRecord::Base
  attr_accessible :answer_id, :creator_id, :kind

  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  belongs_to :answer

  validates :creator, :answer, :kind, :presence => true
  validates_uniqueness_of :answer_id, :scope => :creator_id,
                          :message => "每个回答只允许投票一次"

  after_save :update_vote_sum


  def update_vote_sum
    if self.kind_changed?
      self.answer.vote_sum += 1 if self.kind == 'VOTE_UP'
      self.answer.vote_sum -= 1 if self.kind == 'VOTE_DOWN'
      self.answer.save
    end
  end


  def up
    self.kind = "VOTE_UP"
    self.save
  end


  def down
    self.kind = "VOTE_DOWN"
    self.save
  end


  module UserMethods
    def self.included(base)
      base.has_many :answer_votes, :foreign_key => 'creator_id'
    end
  end
end
