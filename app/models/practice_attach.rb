class PracticeAttach < ActiveRecord::Base
  attr_accessible :practice, :file_entity, :name

  belongs_to :practice


  validates :practice, :file_entity, :name, :presence => true

end