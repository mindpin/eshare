class CourseSign < ActiveRecord::Base
  include CourseInteractive::CourseSignMethods
  attr_accessible :course_id, :user_id, :streak

  belongs_to :user
  belongs_to :course

  validates :user,   :presence => true
  validates :course, :presence => true

  scope :todays_signs, lambda {|course,date|{:conditions =>
    ['course_id=? AND DATE(created_at)=?', course.id, Date.today]
  }}

  scope :todays_signs_for_user, lambda {|course,date,user|
    todays_signs(course,date).where(:user_id => user.id)
  }

  # 课程模型上需要封装某个用户今天是第几个签到的查询方法
  # todays_signs(math).order('id asc').index(sign) + 1
end