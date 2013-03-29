class AnnouncementUser < ActiveRecord::Base
  attr_accessible :announcement, :read, :user

  belongs_to :announcement

  validates :user, :announcement, :read, :presence => true

  scope :by_user, lambda { |user| where(:user_id => user.id) }

end
