class PracticeUpload < ActiveRecord::Base
  attr_accessible :requirement, :creator, :file_entity, :name

  belongs_to :requirement, :class_name => 'PracticeRequirement', :foreign_key => :requirement_id
  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  belongs_to :file_entity


  validates :requirement, :creator, :file_entity, :name, :presence => true

end