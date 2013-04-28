class CourseInteractive < ActiveRecord::Base
  attr_accessible :date, :sum

  belongs_to :course

  validates :course, :date, :sum, :presence => true

  scope :by_date, lambda { |date| 
    di = date.strftime("%Y%m%d").to_i
    {
      :conditions => {:date => di}
    }
  }

  module CourseMethods
    extend ActiveSupport::Concern

    class Weights
      TODAY_CHAPTER_QUESTION_COUNT = 1
      TODAY_SIGN_COUNT = 1
    end

    included do
      has_many :course_interactives
    end

    module ClassMethods
      def top_interactive_sums(date)
        di = date.strftime("%Y%m%d").to_i

        unscoped
          .joins(%~
            LEFT OUTER JOIN course_interactives 
            ON course_interactives.course_id = courses.id 
            AND course_interactives.date = #{di}
          ~)
          .order('course_interactives.sum DESC')
          .group(:id)
      end

      def top_interactive_sums_of(start_date, end_date)
        dia = start_date.strftime("%Y%m%d").to_i
        dib = end_date.strftime("%Y%m%d").to_i

        dia, dib = dib, dia if dia > dib

        unscoped
          .select('courses.*, SUM(course_interactives.sum) suma')
          .joins(%~
            LEFT OUTER JOIN course_interactives 
            ON course_interactives.course_id = courses.id 
            AND course_interactives.date >= #{dia} 
            AND course_interactives.date <= #{dib}
          ~)
          .order('suma DESC')
          .group(:id)
      end
    end

    def rank(date = nil)
      d = date || Date.today

      interactive = self.course_interactives.by_date(d).first

      # 如果今天的值没有记录，直接返回最后一名
      return Course.count if interactive.blank?

      # 否则统计所有互动值较大的课程
      return CourseInteractive.by_date(d).where('sum > ?', interactive.sum).count + 1
    end

    def today_chapter_question_count
      Question.by_course(self).on_date(Date.today).count
    end

    def query_interactive_sum(date)
      ci = self.course_interactives.by_date(date).first
      ci.blank? ? 0 : ci.sum
    end

    def calculate_today_interactive_sum
      today_chapter_question_count * Weights::TODAY_CHAPTER_QUESTION_COUNT +
        today_signs_count * Weights::TODAY_SIGN_COUNT
    end

    def _calculate_today_interactive_sum_and_save
      sum = calculate_today_interactive_sum

      today = Date.today
      di = today.strftime("%Y%m%d").to_i

      ci = self.course_interactives.by_date(today).first

      if ci.blank?
        self.course_interactives.create(:date => di, :sum => sum)
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
      c = self.course
      return true if c.blank?

      c._calculate_today_interactive_sum_and_save
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
