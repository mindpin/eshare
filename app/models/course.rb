class Course < ActiveRecord::Base
  include CourseZipImporter
  include CourseInteractive::CourseMethods
  include CourseSignModule
  include CourseReadPercent::CourseMethods

  attr_accessible :name, :cid, :desc, :syllabus, :cover, :creator

  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  has_many :chapters
  has_many :course_wares, :through => :chapters
  has_many :course_ware_readings, :through => :course_wares

  has_many :test_questions
  has_one  :test_option
  
  has_many :course_signs

  has_many :test_papers

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
  end
end
