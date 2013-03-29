class Announcement < ActiveRecord::Base
  attr_accessible :title, :content, :creator_id

  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  has_many :announcement_users

  validates :creator, :title, :content, :presence => true

  after_save :read_by_user
  

  default_scope order('id desc')


  def read_by_user(user = creator)
    self.announcement_users.create(:user => user, :read => true)
  end

  def has_readed?(user)
    self.announcement_users.by_user(user).count > 0
  end


  module UserMethods
    def self.included(base)
      base.has_many :announcements, :foreign_key => 'creator_id'
    end
  end
end
