class HomeworkUpload < ActiveRecord::Base
  attr_accessible :file_entity_id, :name, :creator

  belongs_to :file_entity
  belongs_to :creator, :class_name => 'User'
  belongs_to :requirement, :class_name => 'HomeworkRequirement'

  validates :file_entity_id, :name, :creator, :requirement,
            :presence => true

  scope :by_creator, lambda {|user| {:conditions => {:creator_id => user.id}}}
end