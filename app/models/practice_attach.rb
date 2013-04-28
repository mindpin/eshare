class PracticeAttach < ActiveRecord::Base
  attr_accessible :practice, :file_entity, :name

  belongs_to :practice
  belongs_to :file_entity


  validates :file_entity, :name, :presence => true

end