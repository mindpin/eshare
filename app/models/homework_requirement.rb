class HomeworkRequirement < ActiveRecord::Base
  attr_accessible :content

  belongs_to :homework

  validates :content, :homework, :presence => true
end