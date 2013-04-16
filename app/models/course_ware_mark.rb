class CourseWareMark < ActiveRecord::Base
  attr_accessible :course_ware, :user, :position, :content

  belongs_to :user
  belongs_to :course_ware

  validates :course_ware,    :presence => true
  validates :user,    :presence => true
  validates :position,    :presence => true
  validates :content,    :presence => true

  scope :by_position, lambda { |position| { :conditions => ['course_ware_marks.position = ?', position] } }
end