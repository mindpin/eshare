class CourseSubject < ActiveRecord::Base
  attr_accessible :title, :desc, :creator

  belongs_to :creator, :class_name => 'User'

  validates :title, :desc, :creator, :presence => true

  scope :by_user, lambda{|user| {:conditions => ['creator_id = ?', user.id]} }

  def main_manager
    creator
  end

  module UserMethods
    def self.included(base)
      base.has_many :created_course_subjects, :class_name => "CourseSubject",
                    :foreign_key => :creator_id
    end
  end

  include CourseSubjectCourse::CourseSubjectMethods
  include CourseSubjectManagership::CourseSubjectMethods
  include CourseSubjectFollow::CourseSubjectMethods
end