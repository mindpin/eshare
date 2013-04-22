class Practice < ActiveRecord::Base
  attr_accessible :title, :content, :chapter, :creator

  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  belongs_to :chapter


  has_many :attaches, :class_name => 'PracticeAttach', :foreign_key => :practice_id
  has_many :requirements, :class_name => 'PracticeRequirement', :foreign_key => :practice_id


  validates :title, :content, :chapter, :creator, :presence => true

end