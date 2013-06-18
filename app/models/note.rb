class Note < ActiveRecord::Base

  attr_accessible :content, 
                  :image, 
                  :is_private, 
                  :course_ware, 
                  :chapter, 
                  :course, 
                  :creator_id

  belongs_to :creator, :class_name => 'User',:foreign_key => :creator_id

  belongs_to :chapter
  belongs_to :course
  belongs_to :course_ware

  validates :content, :presence => true
  validates :creator, :presence => true

  # carrierwave
  mount_uploader :image, NoteUploader

  before_save :note_before_save
  def note_before_save
    if !course_ware.blank?
      self.chapter = course_ware.chapter
      self.course = chapter.course
      return true
    end

    if !chapter.blank?
      self.course = chapter.course
    end
  end

  scope :by_course,       lambda { |course| where(:course_id => course.id) }
  scope :by_chapter,      lambda { |chapter| where(:chapter_id => chapter.id) }
  scope :by_course_ware,  lambda { |course_ware| where(:course_ware_id => course_ware.id) }
  scope :by_privacy,      lambda { where(:is_private => true) }
  scope :by_publicity,    lambda { where(:is_private => false) }

  module UserMethods
    # 1 可以用 user.notes.create 创建笔记
    def self.included(base)
      base.has_many :notes, :foreign_key => 'creator_id'
    end
  end
  
  module ChapterMethods
    def self.included(base)
      base.has_many :notes
    end
  end

  module CourseMethods
    def self.included(base)
      base.has_many :notes
    end
  end

  module CourseWareMethods
    def self.included(base)
      base.has_many :notes
    end
  end
end