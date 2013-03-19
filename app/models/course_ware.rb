class CourseWare < ActiveRecord::Base
  attr_accessible :title, :desc

  validates :title, :desc, :chapter, :creator,
            :presence => true
            
  belongs_to :chapter
  belongs_to :creator, :class_name => 'User'
end