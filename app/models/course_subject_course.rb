class CourseSubjectCourse < ActiveRecord::Base
  attr_accessible :course_subject, :course

  belongs_to :course
  belongs_to :course_subject

  validates :course, :course_subject, :presence => true

  scope :by_course, lambda{|course| {:conditions => ['course_id = ?', course.id]} }

  module CourseSubjectMethods
    def self.included(base)
      base.has_many :course_subject_courses
      base.has_many :courses, :through => :course_subject_courses
    end

    def add_course(course, user)
      return if !CourseSubject.by_user(user).first
      return if self.course_subject_courses.by_course(course).first
      self.course_subject_courses.create(:course => course)
    end

    def remove_course(course, user)
      return if !CourseSubject.by_user(user).first
      course_subject_course = self.course_subject_courses.by_course(course).first
      course_subject_course.destroy if course_subject_course
    end
  end

end