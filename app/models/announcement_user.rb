class AnnouncementUser < ActiveRecord::Base
  attr_accessible :announcement, :read, :user

  belongs_to :user
  belongs_to :announcement

  validates :user, :announcement, :read, :presence => true
  validates_uniqueness_of :announcement_id, :scope => :user_id

  scope :by_user, lambda { |user| where(:user_id => user.id) }

end
