class Activity < ActiveRecord::Base
  attr_accessible :title, :content, :start_time, :end_time

  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id

  validates  :creator, :presence => true
  validates  :title,   :presence => true
  validates  :content, :presence => true

  validates :start_time, :end_time, :presence => true

  validate :validate_start_and_end_time

  def validate_start_and_end_time
    errors.add(:base,'开始时间必须早于结束时间') if self.start_time > self.end_time
  end

  module UserMethods
    def self.included(base)
      base.has_many :activities, :foreign_key => :creator_id
    end
  end

  include ActivityMembership::ActivityMethods
end