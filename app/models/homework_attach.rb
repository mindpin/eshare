class HomeworkAttach < ActiveRecord::Base
  attr_accessible :file_entity, :name

  belongs_to :homework
  belongs_to :file_entity

  validates :file_entity, :name, :presence => true
end