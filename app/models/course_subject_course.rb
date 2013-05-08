class CourseSubjectCourse < ActiveRecord::Base
  attr_accessible :course_subject, :course, :manager_id

  belongs_to :course
  belongs_to :course_subject

  validates :course, :course_subject, :presence => true

  validates :course_id, :uniqueness => {:scope => :course_subject_id}

  scope :by_course,  lambda{|course| {:conditions => ['course_id = ?', course.id]} }
  scope :by_manager, lambda{|user| {:conditions => ['manager_id = ?', user.id]} }

  module CourseSubjectMethods
    def self.included(base)
      base.has_many :course_subject_courses
      base.has_many :courses, :through => :course_subject_courses
    end

    def add_course(course, user)
      return if !self.is_manager?(user) || self.courses.include?(course)
      self.course_subject_courses.create(:course => course, :manager_id => user.id)
    end

    def remove_course(course, user)
      return if !self.is_manager?(user)
      self.course_subject_courses.by_course(course).destroy_all
    end

    def is_manager?(user)
      self.main_manager == user || self.secondary_managers.include?(user)
    end

  end

end