# -*- coding: utf-8 -*-
class Course < ActiveRecord::Base
  include CourseZipImporter
  include CourseZipExporter
  include CourseInteractive::CourseMethods
  include CourseSignModule
  include CourseReadPercent::CourseMethods
  include CourseFeedTimelime::CourseMethods
  include YoukuVideoList::CourseMethods
  include TudouVideoList::CourseMethods
  include CourseFav::CourseMethods
  include SelectCourseApply::CourseMethods

  simple_taggable
  BASE_TAGS = %w(
    计算机技术
    数学与逻辑学
    实验与理论科学
    机械与工程
    历史与社会
    哲学与伦理
    认知与心理
    天文与地理
    医学与生理
    生物与环境科学
    经济管理与法律
    语言文学
    艺术审美
    动漫创作
    教育学
    游戏
    生活
  )
  
  def replace_public_tags(tags_str, user)
    self.remove_public_tag self.public_tags.map(&:name).join(' ')
    self.set_tag_list(tags_str, :user => user, :force_public => true)
  end

  attr_accessible :name, :cid, :desc, :syllabus, :cover, :creator

  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  has_many :chapters
  has_many :practices, :through => :chapters
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

  default_scope order('courses.id desc')
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

  # 用户学习进度排名
  def users_rank
    sql = %~
      SELECT * FROM
      (
        SELECT sum(course_ware_readings.read_percent) AS SUM, course_ware_readings.user_id AS USER_ID, courses.id
        FROM course_ware_readings
        JOIN course_wares ON course_wares.id = course_ware_readings.course_ware_id
        JOIN chapters ON chapters.id = course_wares.chapter_id
        JOIN courses ON courses.id = chapters.course_id
        WHERE courses.id = #{self.id}
        GROUP BY course_ware_readings.user_id
      ) AS Q
      ORDER BY SUM DESC
    ~

    result = Course.find_by_sql sql

    index = 0 
    result.map do |r|
      index = index + 1
      {
        :user => User.find_by_id(r['USER_ID']),
        :sum => r['SUM'],
        :index => index
      }
    end
  end

  def user_rank_of(user)
    users_rank.each do |r|
      return r[:index] if user == r[:user]
    end

    return '无'
  end

  module UserMethods
    def self.included(base)
      base.has_many :courses, :foreign_key => 'creator_id'
    end

    # 统计所有年份中，按照月份和星期分布的学习进度
    def course_weekdays_stat
      sql = %~
        SELECT weekday, month, SUM(percent_change) AS COUNT
        FROM course_ware_reading_delta
        WHERE user_id = #{self.id}
        GROUP BY weekday, month
      ~

      result = CourseWareReadingDelta.find_by_sql sql
      hash = Hash.new Hash.new

      max = 0

      result.each do |r|
        hash[r.month] = {} if hash[r.month].blank?
        count = r['COUNT'].to_i
        hash[r.month][r.weekday] = count
        max = [max, count].max
      end

      hash[:max] = max
      hash
    end

    # 统计已学的，未学的，正在学的课程的个数
    def course_read_stat
      sql = %~
        SELECT COUNT(*) AS C FROM

        (
          SELECT Q.id, COUNT(Q.CWID) AS COURSE_WARE_COUNT, SUM(Q.read IS TRUE) AS HAS_READ, SUM(Q.read IS NOT TRUE AND P > 0) AS READING
          FROM
          (
              SELECT courses.id, course_wares.id AS CWID, (course_ware_readings.read_count / course_wares.total_count) AS P, course_ware_readings.read
              FROM courses
              INNER JOIN chapters ON chapters.course_id = courses.id
              INNER JOIN course_wares ON course_wares.chapter_id = chapters.id
              LEFT OUTER JOIN course_ware_readings 
                ON course_ware_readings.course_ware_id = course_wares.id
                AND course_ware_readings.user_id = #{self.id}
          ) AS Q
          GROUP BY Q.id

        ) AS Q1

        WHERE COURSE_WARE_COUNT > 0 AND ?
      ~

      read    = Course.count_by_sql sql.sub('?', 'COURSE_WARE_COUNT = HAS_READ')
      reading = Course.count_by_sql sql.sub('?', 'READING > 0')
      none = Course.count - reading - read

      return {
        :none => none,
        :read => read,
        :reading => reading
      }
    end
  end
end
