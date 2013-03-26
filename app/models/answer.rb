class Answer < ActiveRecord::Base
  attr_accessible :content

  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  belongs_to :question

  validates :creator, :question, :content, :presence => true


  default_scope order('id desc')
  max_paginates_per 50



  module UserMethods
    def self.included(base)
      base.has_many :answers, :foreign_key => 'creator_id'
    end
  end
end
