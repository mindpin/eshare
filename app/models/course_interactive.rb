class CourseInteractive < ActiveRecord::Base
  attr_accessible :date, :sum

  belongs_to :course

  validates :course, :date, :sum, :presence => true

  scope :by_date, lambda {|date| {:conditions => {:date => date}}}

  module CourseMethods

    class Weights
      TODAY_CHAPTER_QUESTION_COUNT = 1
      TODAY_SIGN_COUNT = 1
    end

    def self.included(base)
      base.has_many :course_interactives
    end

    def today_chapter_question_count
      Question.by_course(self).today.count
    end

    def query_interactive_sum(date)
      ci = self.course_interactives.by_date(date).first
      ci.blank? ? 0 : ci.sum
    end

    def calculate_today_interactive_sum
      today_chapter_question_count * Weights::TODAY_CHAPTER_QUESTION_COUNT +
        today_sign_count * Weights::TODAY_SIGN_COUNT
    end

    def _calculate_today_interactive_sum_and_save
      sum = calculate_today_interactive_sum

      date = Time.now.strftime("%Y%m%d").to_i
      ci = self.course_interactives.by_date(date).first

      if ci.blank?
        self.course_interactives.create(:date => date, :sum => sum)
      else
        ci.update_attributes(:sum => sum)
      end

    end
  end

  module QuestionMethods
    def self.included(base)
      base.after_save :check_course_interactive
    end

    def check_course_interactive
      return true if self.chapter.blank?
      course = self.chapter.course
      return true if course.blank?

      course._calculate_today_interactive_sum_and_save
    end
  end

  module CourseSignMethods
    def self.included(base)
      base.after_save :check_course_interactive
    end

    def check_course_interactive
      return true if self.course.blank?

      course._calculate_today_interactive_sum_and_save
    end
  end
end
