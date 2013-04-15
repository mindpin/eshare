class CourseSign < ActiveRecord::Base
  include CourseInteractive::CourseSignMethods
  attr_accessible :course, :user, :streak

  belongs_to :user
  belongs_to :course

  validates :user,   :presence => true
  validates :course, :presence => true
  validates :user_id,   :uniqueness => {:scope => :course_id}

  scope :of_course, lambda { |course|
    { :conditions => ['course_id = ?', course.id] }
  }

  scope :on_date, lambda { |date|
    { :conditions => ['DATE(created_at) = ?', date] }
  }

  scope :of_user, lambda { |user|
    { :conditions => ['user_id = ?', user.id]}
  }
end