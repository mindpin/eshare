class Answer < ActiveRecord::Base
  attr_accessible :content, :question_id, :creator_id

  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  belongs_to :question
  has_many :answer_votes

  validates :creator, :question, :content, :presence => true
  validates_uniqueness_of :question_id, :scope => :creator_id,
                          :message => "只允许回复一次"


  default_scope order('vote_sum desc')


  def has_voted_by?(user)
    self.answer_votes.by_user(user).count > 0
  end


  module UserMethods
    def self.included(base)
      base.has_many :answers, :foreign_key => 'creator_id'
    end
  end
end
