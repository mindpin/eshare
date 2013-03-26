class Course < ActiveRecord::Base
  attr_accessible :name, :cid, :desc, :syllabus, :cover

  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  has_many :chapters
  has_many :course_wares, :through => :chapters
  has_many :test_questions

  has_many :test_papers

  validates :creator, :name, :cid, :desc, :syllabus, :presence => true


  default_scope order('id desc')
  max_paginates_per 50

  # carrierwave
  mount_uploader :cover, CourseCoverUploader

  # excel import
  simple_excel_import :course, :fields => [:name, :cid, :desc, :syllabus]
  def self.import(excel_file, creator)
    courses = self.parse_excel_course excel_file
    courses.each do |c|
      c.creator = creator
      c.save
    end
  end

  module UserMethods
    def self.included(base)
      base.has_many :courses, :foreign_key => 'creator_id'
    end
  end
end