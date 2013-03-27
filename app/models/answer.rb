class Answer < ActiveRecord::Base
  attr_accessible :content

  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  belongs_to :question
  has_many :answer_votes

  validates :creator, :question, :content, :presence => true
  validates_uniqueness_of :question_id, :scope => :creator_id,
                          :message => "reply only one time limitly"


  default_scope order('vote_sum desc')


  module UserMethods
    def self.included(base)
      base.has_many :answers, :foreign_key => 'creator_id'
    end
  end
end
