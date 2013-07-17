# -*- coding: utf-8 -*-
class CourseDepend < ActiveRecord::Base
  attr_accessible :before_course_id, :after_course_id

  belongs_to :before_course, :class_name => 'CourseDepend', :foreign_key => :before_course_id
  belongs_to :after_course, :class_name => 'CourseDepend', :foreign_key => :after_course_id

  validates :before_course_id, :uniqueness => {:scope => :after_course_id}

  module CourseMethods
    def self.included(base)
      base.has_many(:before_courses,
                    :class_name => 'CourseDepend',
                    :foreign_key => :before_course_id)

      base.has_many(:after_courses,
                    :class_name => 'CourseDepend',
                    :foreign_key => :after_course_id)

      base.send :include, InstanceMethods
    end

    module InstanceMethods

      def before_courses
        return [] if before_courses.blank?
        before_courses.where(:before_course_id => id)
      end

      def after_courses
        return [] if after_courses.blank?
        before_courses.where(:after_course_id => id)
      end

      def add_before_course(course)
        before_courses.where(:before_course_id => course.id).first_or_create
      end

      def add_after_course(course)
        after_courses.where(:after_course_id => course.id).first_or_create
      end

    end

  end

end