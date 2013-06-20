# -*- coding: utf-8 -*-
class CourseAttitude < ActiveRecord::Base
  VALID_KINDS = %w(LIKE NORMAL HATE)

  attr_accessible :user, :course, :kind, :content

  belongs_to :user
  belongs_to :course

  validates :user_id, :uniqueness => {:scope => :course_id}
  validates :kind,    :inclusion  => {:in => VALID_KINDS}

  module CourseMethods
    def self.included(base)
      base.has_many(:attitude_users,
                    :class_name => "User",
                    :through    => :course_attitudes,
                    :source     => :user)
      base.has_many :course_attitudes
      base.send :include, InstanceMethods
    end

    module InstanceMethods
      def attitude_users_count
        attitude_users.count
      end

      def attitude_users_with_kind(kind)
        attitude_users.joins(:course_attitudes).where(:course_attitudes => {:kind => kind})
      end

      CourseAttitude::VALID_KINDS.each do |kind|
        define_method :"#{kind.downcase}_attitude_users" do
          attitude_users_with_kind(kind)
        end

        define_method :"#{kind.downcase}_attitude_users_count" do
          attitude_users_with_kind(kind).count
        end
      end

      def get_user_attitude_kind_of(user)
        ca = self.course_attitudes.where(:user_id => user.id).first

        return 'NONE' if ca.blank?
        return ca.kind
      end

      def get_user_attitude_content_of(user)
        ca = self.course_attitudes.where(:user_id => user.id).first

        return '' if ca.blank?
        return ca.content
      end
    end
  end

  module UserMethods
    def self.included(base)
      base.has_many(:attitude_courses,
                    :class_name => "Course",
                    :through    => :course_attitudes,
                    :source     => :course)
      base.has_many :course_attitudes
      base.send :include, InstanceMethods
    end

    module InstanceMethods
      def set_course_attitude(course, kind, content = nil)
        record = self.get_course_attitude(course)
        record.update_attributes(:kind => kind, :content => content)
        record
      end

      def get_course_attitude(course)
        CourseAttitude.find_or_initialize_by_user_id_and_course_id(self.id, course.id)
      end
    end
  end
end
