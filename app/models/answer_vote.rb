class AnswerVote < ActiveRecord::Base
  attr_accessible :kind

  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  belongs_to :answer

  validates :creator, :answer, :kind, :presence => true
  validates_uniqueness_of :answer_id, :scope => :creator_id,
                          :message => "每个回答只允许投票一次"



  module UserMethods
    def self.included(base)
      base.has_many :answer_votes, :foreign_key => 'creator_id'
    end
  end
end
