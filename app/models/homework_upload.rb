class HomeworkUpload < ActiveRecord::Base
  attr_accessible :file_entity, :name

  belongs_to :file_entity
  belongs_to :creator, :class_name => 'User'
  belongs_to :requirement, :class_name => 'HomeworkRequirement'

  validates :file_entity, :name, :creator, :requirement,
            :presence => true
end