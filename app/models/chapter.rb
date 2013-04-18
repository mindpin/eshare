class Chapter < ActiveRecord::Base
  include MovePosition::ModelMethods
  include CourseReadPercent::ChapterMethods

  attr_accessible :title, :desc, :creator

  belongs_to :course
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"

  validates :title, :presence => true
  validates :course,  :presence => true
  validates :creator, :presence => true

  has_many :course_wares
  has_many :homeworks
  has_many :questions

  scope :by_course, lambda{|course| {:conditions => ['course_id = ?', course.id]} }

  def prev
    self.class.by_course(course).where('position < ?', self.position).last
  end

  def next
    self.class.by_course(course).where('position > ?', self.position).first
  end

end
