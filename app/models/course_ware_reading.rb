class CourseWareReading < ActiveRecord::Base
  include CourseWareReadingDelta::CourseWareReadingMethods

  attr_accessible :user, :read, :read_count, :course_ware

  belongs_to :user
  belongs_to :course_ware

  validate  :validate_read_status

  scope :by_user, lambda { |user| { :conditions => ['course_ware_readings.user_id = ?', user.id] } }
  scope :by_read, lambda { |read| { :conditions => ['course_ware_readings.read = ?', read] } }

  def validate_read_status
    total_count = self.course_ware.total_count
    return true if total_count.blank? || read_count.blank?

    errors.add(:base, 'read_count > total_count 错误 ')  if read_count > total_count
    errors.add(:base, 'read_count == total_count && !read 错误')  if read_count == total_count && !read
  end
end
