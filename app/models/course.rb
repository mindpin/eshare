class Course < ActiveRecord::Base
  attr_accessible :name, :cid, :desc, :syllabus, :cover

  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  has_many :chapters
  has_many :course_wares, :through => :chapters

  validates :creator, :name, :cid, :desc, :syllabus, :presence => true


  default_scope order('id desc')
  max_paginates_per 50

  # carrierwave
  mount_uploader :cover, CourseCoverUploader

  module UserMethods
    def self.included(base)
      base.has_many :courses, :foreign_key => 'creator_id'
    end
  end
end