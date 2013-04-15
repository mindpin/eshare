class CourseSign < ActiveRecord::Base
  include CourseInteractive::CourseSignMethods
  attr_accessible :course, :user, :streak

  belongs_to :user
  belongs_to :course

  validates :user,    :presence => true
  validates :course,  :presence => true
  validate :should_not_repeat_sign_in_one_day
  def should_not_repeat_sign_in_one_day
    course = self.course
    user = self.user
    date = Date.today
    if course.course_signs.of_user(user).on_date(date).first.present?
      errors.add :base, 'should_not_repeat_sign_in_one_day'
    end
    return true
  end

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