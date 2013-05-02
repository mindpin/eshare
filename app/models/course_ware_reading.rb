class CourseWareReading < ActiveRecord::Base
  include CourseWareReadingDelta::CourseWareReadingMethods

  attr_accessible :user, :read, :read_count, :course_ware

  belongs_to :user
  belongs_to :course_ware

  validate  :validate_read_status
  def validate_read_status
    total_count = course_ware.total_count || 0
    rc = read_count || 0

    return true if rc == 0

    if rc > total_count
      errors.add(:base, '阅读进度超出上限')
      return false
    end

    if !!read == false && rc == total_count
      errors.add(:base, '阅读已完成，但尝试标记为未读')
      return false
    end
  end

  scope :by_user, lambda { |user| { :conditions => ['course_ware_readings.user_id = ?', user.id] } }
  scope :by_read, lambda { |read| { :conditions => ['course_ware_readings.read = ?', read] } }

  before_save :set_default_read_count_and_percent
  def set_default_read_count_and_percent
    self.read_count = 0 if self.read_count.blank?
    self.read_percent = _get_percent
  end

  def _get_percent
    total_count = self.course_ware.total_count

    if total_count.blank? || total_count == 0
      return self.read ? '100%' : '0%'
    end

    p = [(self.read_count.to_f * 100 / total_count).round, 100].min
    return "#{p}%"
  end

  # 记录用户活动
  record_feed :scene => :course_ware_readings,
                        :callbacks => [ :create, :update]
end
