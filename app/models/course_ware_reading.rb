class CourseWareReading < ActiveRecord::Base
  attr_accessible :user_id, :course_ware_id, :read

  belongs_to :user
  belongs_to :course_ware

  scope :read_for_course_ware, lambda {|course_ware|{:conditions =>
    ['course_ware_id = ?', course_ware.id]
  }}

  scope :course_ware_reading_for_user, lambda {|course_ware,user|
    read_for_course_ware(course_ware).where(:user_id => user.id)
  }
end