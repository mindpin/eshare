class Question < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  has_many :answers

  validates :creator, :title, :content, :presence => true


  default_scope order('id desc')
  max_paginates_per 50



  module UserMethods
    def self.included(base)
      base.has_many :questions, :foreign_key => 'creator_id'
    end
  end
end