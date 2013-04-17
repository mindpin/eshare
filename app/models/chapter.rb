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


  def prev   
    self.class.last(:conditions => ['position < ?', self.position])
  end

  def next
    self.class.first(:conditions => ['position > ?', self.position])
  end


  def set_position
    self.position = self.id
    self.save
  end

  def move_down
    next_chapter = self.next
    return nil if next_chapter.nil?

    position = self.position
    self.position = next_chapter.position
    self.save
    
    next_chapter.position = position
    next_chapter.save
    
    self
  end

  def move_up
    prev_chapter = self.prev
    return nil if prev_chapter.nil?

    position = self.position
    self.position = prev_chapter.position
    self.save
    
    prev_chapter.position = position
    prev_chapter.save

    self
  end

end
