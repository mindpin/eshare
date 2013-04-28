class PracticeRequirement < ActiveRecord::Base
  attr_accessible :practice, :content

  belongs_to :practice
  has_many :uploads, :class_name => 'PracticeUpload', :foreign_key => :requirement_id

  validates :content, :presence => true

end