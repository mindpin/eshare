class Question < ActiveRecord::Base
  attr_accessible :title, :content


  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  has_many :answers

  validates :creator, :title, :content, :presence => true


  default_scope order('id desc')


  module UserMethods
    def self.included(base)
      base.has_many :questions, :foreign_key => 'creator_id'
    end
  end
end