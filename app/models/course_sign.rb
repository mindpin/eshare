class CourseSign < ActiveRecord::Base
  attr_accessible :course_id, :user_id, :streak

  belongs_to :user
  belongs_to :course

  validates :user,   :presence => true
  validates :course, :presence => true
  validates :user_id,   :uniqueness => {:scope => :course_id}

  scope :current_signs, lambda {|course,date|{:conditions =>
    ['course_id=? AND DATE(created_at)=?', course.id, Date.today]
  }}

  scope :current_signs_for_user, lambda {|course,date,user|
    current_signs(course,date).where(:user_id => user.id)
  }
end