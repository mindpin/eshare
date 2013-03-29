class Announcement < ActiveRecord::Base
  attr_accessible :title, :content, :creator_id

  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  has_many :announcement_users

  validates :creator, :title, :content, :presence => true
  

  default_scope order('id desc')


  module UserMethods
    def self.included(base)
      base.has_many :announcements, :foreign_key => 'creator_id'
    end
  end
end
