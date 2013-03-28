class HomeworkAttach < ActiveRecord::Base
  attr_accessible :file_entity_id, :name

  belongs_to :homework
  belongs_to :file_entity

  validates :file_entity_id, :name, :presence => true
end