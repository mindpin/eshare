class Course < ActiveRecord::Base
  include CourseZipImporter
  include CourseInteractive::CourseMethods
  include CourseSignModule
  include CourseReadPercent::CourseMethods
  include CourseFeedTimelime::CourseMethods
  include YoukuVideoList::CourseMethods

  attr_accessible :name, :cid, :desc, :syllabus, :cover, :creator

  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  has_many :chapters
  has_many :course_wares, :through => :chapters
  has_many :course_ware_readings, :through => :course_wares

  has_many :test_questions
  has_one  :test_option
  
  has_many :course_signs

  has_many :test_papers

  has_many :questions, :as => :model

  validates :creator, :presence => true

  validates :name, :uniqueness => {:case_sensitive => false},
                   :presence => true

  validates :cid, :uniqueness => {:case_sensitive => false},
                  :presence => true

  default_scope order('id desc')
  max_paginates_per 50

  # 最近被指定用户学习过的课程
  scope :recent_read_by, lambda { |user|
    joins(:course_ware_readings)
      .where('course_ware_readings.user_id = ?', user.id)
      .group(:id)
      .order('course_ware_readings.updated_at DESC')
  }

  # carrierwave
  mount_uploader :cover, CourseCoverUploader

  # excel import
  simple_excel_import :course, :fields => [:name, :cid, :desc]
  def self.import(excel_file, creator)
    courses = self.parse_excel_course excel_file
    courses.each do |c|
      c.creator = creator
      c.save
    end
  end

  # 问题数统计
  def questions_count
    self.chapters.map { |c| c.questions.count }.sum
  end

  module UserMethods
    def self.included(base)
      base.has_many :courses, :foreign_key => 'creator_id'
    end

    def course_read_stat
      sql = %~
        SELECT COUNT(*) AS C FROM

        (
          SELECT Q.id, COUNT(Q.CWID) AS COURSE_WARE_COUNT, SUM(Q.read IS TRUE) AS HAS_READ, SUM(Q.read IS NOT TRUE AND P > 0) AS READING
          FROM
          (
              SELECT courses.id, course_ware_readings.id AS CWID, (course_ware_readings.read_count / course_wares.total_count) AS P, course_ware_readings.read
              FROM courses
              INNER JOIN chapters ON chapters.course_id = courses.id
              INNER JOIN course_wares ON course_wares.chapter_id = chapters.id
              LEFT OUTER JOIN course_ware_readings 
                ON course_ware_readings.course_ware_id = course_wares.id
                AND course_ware_readings.user_id = #{self.id}
          ) AS Q
          GROUP BY Q.id

        ) AS Q1

        ?
      ~

      read    = Course.count_by_sql sql.sub('?', 'WHERE COURSE_WARE_COUNT = HAS_READ')
      reading = Course.count_by_sql sql.sub('?', 'WHERE READING > 0')
      none = Course.count - reading - read

      return {
        :none => none,
        :read => read,
        :reading => reading
      }
    end
  end
end
