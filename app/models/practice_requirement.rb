class PracticeRequirement < ActiveRecord::Base
  attr_accessible :practice, :content

  belongs_to :practice

  validates :content, :presence => true

end