# -*- coding: utf-8 -*-
class CourseDepend < ActiveRecord::Base
  attr_accessible :before_course_id, :after_course_id

  belongs_to :before_course, :class_name => 'Course', :foreign_key => :before_course_id
  belongs_to :after_course, :class_name => 'Course', :foreign_key => :after_course_id

  validates :before_course_id, :uniqueness => {:scope => :after_course_id}

  module CourseMethods
    def self.included(base)
      base.has_many :before_course_depends, :class_name => 'CourseDepend', :foreign_key => :before_course_id
      base.has_many :after_courses, :through => :before_course_depends, :source => :after_course
      base.has_many :after_course_depends, :class_name => "CourseDepend", :foreign_key => :after_course_id
      base.has_many :before_courses, :through => :after_course_depends, :source => :before_course

      base.send :include, InstanceMethods
    end

    module InstanceMethods


      def add_before_course(course)
        after_course_depends.where(:before_course_id => course.id).first_or_create
      end

      def add_after_course(course)
        before_course_depends.where(:after_course_id => course.id).first_or_create
      end

    end

  end

end