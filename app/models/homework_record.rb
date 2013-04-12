class HomeworkRecord < ActiveRecord::Base
  attr_accessible :creator, :submitted_at, :status, :checked_at
  STATUS_SUBMITED = "STATUS_SUBMITED"
  STATUS_CHECKED  = "STATUS_CHECKED"
  validates :homework, :creator, :presence => true

  belongs_to :homework
  belongs_to :creator, :class_name => 'User'

  scope :by_creator, lambda{|user|{:conditions => {:creator_id => user.id}}}
end