class PracticeRecord < ActiveRecord::Base
  class Status
    SUBMITTED   = 'SUBMITTED'
    CHECKED   = 'CHECKED'
  end

  attr_accessible :practice, :user, :submitted_at, :checked_at, :status

  belongs_to :practice
  belongs_to :user


  validates :practice, :user, :submitted_at, :presence => true
  validates_uniqueness_of :practice_id, :scope => :user_id


  module UserMethods
    def self.included(base)
      base.has_many :practice_records
    end
  end

end