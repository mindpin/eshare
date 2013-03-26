class Answer < ActiveRecord::Base
  attr_accessible :content

  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  belongs_to :question

  validates :creator, :question, :content, :presence => true
  validates_uniqueness_of :question_id, :scope => :creator_id


  default_scope order('id desc')


  module UserMethods
    def self.included(base)
      base.has_many :answers, :foreign_key => 'creator_id'
    end
  end
end
