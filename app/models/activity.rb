class Activity < ActiveRecord::Base
  STATUS_PREP = 'PREP'
  STATUS_BEGIN = 'BEGIN'
  STATUS_END = 'END'
  attr_accessible :title, :content, :start_time, :end_time, :status

  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id

  validates  :creator, :presence => true
  validates  :title,   :presence => true
  validates  :content, :presence => true
  validates  :status, :inclusion  => [STATUS_PREP, STATUS_BEGIN, STATUS_END]
  validates  :start_time, :presence => true

  validate   :validate_start_time
  def validate_start_time
    # 这个判断是为了程序健壮考虑
    return true if start_time.blank?
    if start_time < Time.now
      errors.add(:base,'活动开始时间必须大于现在')
    end
  end

  validate   :validate_end_time
  def validate_end_time
    # 这个判断是为了程序健壮考虑
    return true if start_time.blank?
    return true if end_time.blank?
    if end_time < Time.now || end_time < start_time
      errors.add(:base,'活动结束时间必须大于开始时间')
    end
  end

  def end!
    return if !self.end_time.blank?
    self.update_attributes :status => STATUS_END
  end

  def refresh_status!
    if Time.now < start_time
      self.update_attributes :status => STATUS_PREP
    elsif !end_time.blank? && Time.now < end_time
      self.update_attributes :status => STATUS_BEGIN
    elsif !end_time.blank? && Time.now > end_time
      self.update_attributes :status => STATUS_END
    end
  end

  module UserMethods
    def self.included(base)
      base.has_many :activities, :foreign_key => :creator_id
    end
  end

  include ActivityMembership::ActivityMethods
end