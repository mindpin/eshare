class Homework < ActiveRecord::Base
  attr_accessible :title, :content, :deadline,
                  :homework_requirements_attributes,
                  :homework_attaches_attributes,
                  :creator, :chapter

  belongs_to :chapter
  belongs_to :creator, :class_name => 'User'

  validates :title, :chapter, :creator,
            :presence => true

  has_many :homework_requirements
  has_many :homework_attaches
  has_many :homework_records
  has_many :homework_uploads, :through => :homework_requirements

  accepts_nested_attributes_for :homework_requirements
  accepts_nested_attributes_for :homework_attaches

  scope :unexpired, :conditions => ['deadline > ?', Time.now]
  scope :expired,   :conditions => ['deadline <= ?', Time.now]
  scope :by_course, lambda {|course| joins(:chapter).where("chapters.course_id = ?", course.id)}

  def submit_by_user(user)
    _change_record_status(user,{
      :status        => HomeworkRecord::STATUS_SUBMITED,
      :submitted_at  => Time.now
    })
  end

  def check_of_user(user)
    _change_record_status(user,{
      :status        => HomeworkRecord::STATUS_CHECKED,
      :checked_at  => Time.now
    })
  end

  def is_submit_by_user?(user)
    record = self.homework_records.by_creator(user).first
    record.present? && record.status == HomeworkRecord::STATUS_SUBMITED
  end

  def is_checked_of_user?(user)
    record = self.homework_records.by_creator(user).first
    record.present? && record.status == HomeworkRecord::STATUS_CHECKED
  end

  def submited_time_by_user(user)
    record = self.homework_records.by_creator(user).first
    record && record.submitted_at
  end

  def checked_time_of_user(user)
    record = self.homework_records.by_creator(user).first
    record && record.checked_at
  end

  private
  def _change_record_status(user, attrs)
    record = self.homework_records.by_creator(user).first || self.homework_records.build(:creator => user)
    record.update_attributes(attrs)
  end

  module UserMethods
    def self.included(base)
      base.has_many :created_homeworks, :class_name => 'Homework',
                    :foreign_key => :creator_id
    end
  end
end
