class TestQuestion < ActiveRecord::Base
  attr_accessible :title, :course_id, :creator_id

  belongs_to :course
  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id

  has_many :test_papers, :through => :test_paper_test_questions

  validates :title,  :presence => true
  validates :course, :presence => true
  validates :creator,:presence => true
end