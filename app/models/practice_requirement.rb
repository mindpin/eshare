class PracticeRequirement < ActiveRecord::Base
  attr_accessible :practice, :content

  belongs_to :practice

  validates :practice, :content, :presence => true

end