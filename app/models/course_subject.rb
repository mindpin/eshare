class CourseSubject < ActiveRecord::Base
  attr_accessible :title, :desc, :creator

  belongs_to :creator, :class_name => 'User'

  validates :title, :desc, :creator, :presence => true

  scope :by_user, lambda{|user| {:conditions => ['creator_id = ?', user.id]} }

  module UserMethods
    def self.included(base)
      base.has_many :course_subjects
    end
  end

  include CourseSubjectCourse::CourseSubjectMethods
  include CourseSubjectManagership::CourseSubjectMethods
end