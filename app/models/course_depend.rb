# -*- coding: utf-8 -*-
class CourseDepend < ActiveRecord::Base
  attr_accessible :before_course_id, :after_course_id

  belongs_to :before_course, :class_name => 'Course', :foreign_key => :before_course_id
  belongs_to :after_course, :class_name => 'Course', :foreign_key => :after_course_id

  validates :before_course_id, :uniqueness => {:scope => :after_course_id}

  module CourseMethods
    def self.included(base)
      base.has_many :a_courses, :class_name => 'CourseDepend', :foreign_key => :before_course_id
      base.has_many :after_courses, :through => :a_courses, :source => :after_course
      base.has_many :b_courses, :class_name => "CourseDepend", :foreign_key => :after_course_id
      base.has_many :before_courses, :through => :b_courses, :source => :before_course

      base.send :include, InstanceMethods
    end

    module InstanceMethods


      def add_before_course(course)
        b_courses.where(:before_course_id => course.id).first_or_create
      end

      def add_after_course(course)
        a_courses.where(:after_course_id => course.id).first_or_create
      end

    end

  end

end