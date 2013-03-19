class Course < ActiveRecord::Base 
  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  has_many :chapters
  has_many :course_wares, :through => :chapters

  validates :creator, :name, :cid, :desc, :syllabus, :presence => true
end