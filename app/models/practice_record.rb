class PracticeRecord < ActiveRecord::Base
  attr_accessible :practice, :user, :submitted_at, :checked_at, :status

  belongs_to :practice
  belongs_to :user


  validates :practice, :user, :submitted_at, :checked_at, :presence => true

end