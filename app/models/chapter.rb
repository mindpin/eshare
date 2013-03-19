class Chapter < ActiveRecord::Base
  attr_accessible :title, :creator_id, :desc

  #belongs_to :course
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"

  validates :title, :presence => true
  #validates :course,  :presence => true
  validates :creator, :presence => true

end