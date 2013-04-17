class Chapter < ActiveRecord::Base
  attr_accessible :title, :desc, :creator

  belongs_to :course
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"

  validates :title, :presence => true
  validates :course,  :presence => true
  validates :creator, :presence => true

  has_many :course_wares
  has_many :homeworks
  has_many :questions

  default_scope order('position ASC')

  after_create :set_position


  def set_position
    self.position = self.id
    self.save
  end


  include MovePosition::ModelMethods

end
