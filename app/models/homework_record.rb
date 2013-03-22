class HomeworkRecord < ActiveRecord::Base
  validates :homework, :creator, :presence => true

  belongs_to :homework
  belongs_to :creator, :class_name => 'User'
end