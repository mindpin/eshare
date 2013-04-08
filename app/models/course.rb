class Course < ActiveRecord::Base
  include CourseZipImporter

  attr_accessible :name, :cid, :desc, :syllabus, :cover, :creator

  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  has_many :chapters
  has_many :course_wares, :through => :chapters

  validates :creator, :presence => true

  validates :name, :uniqueness => {:case_sensitive => false},
                   :presence => true

  validates :cid, :uniqueness => {:case_sensitive => false},
                  :presence => true

  default_scope order('id desc')
  max_paginates_per 50

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

  module UserMethods
    def self.included(base)
      base.has_many :courses, :foreign_key => 'creator_id'
    end
  end
end
