class AnswerCourseWare < ActiveRecord::Base
  belongs_to :answer
  belongs_to :course_ware

  module CourseWareMethods
    def self.included(base)
      base.has_many :answer_course_wares
      base.has_many :answers, :through => :answer_course_wares
    end
  end

  module AnswerMethods
    def self.included(base)
      base.has_many :answer_course_wares
      base.has_many :course_wares, :through => :answer_course_wares

      base.send :include, InstanceMethods
    end

    module InstanceMethods
      def add_course_ware(course_ware)
        self.course_wares << course_ware
      end
    end
  end
end
