class Practice < ActiveRecord::Base

  attr_accessible :title, :content, :chapter, :creator, 
                  :attaches_attributes, :requirements_attributes

  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  belongs_to :chapter


  has_many :attaches, :class_name => 'PracticeAttach', :foreign_key => :practice_id
  has_many :requirements, :class_name => 'PracticeRequirement', :foreign_key => :practice_id
  has_many :records, :class_name => 'PracticeRecord', :foreign_key => :practice_id
  has_many :uploads, :through => :records

  accepts_nested_attributes_for :attaches
  accepts_nested_attributes_for :requirements


  validates :title, :chapter, :creator, :presence => true


  def submit_by_user(user)
    self.records.create(
      :practice => self,
      :user => user,
      :submitted_at => Time.now,
      :status => PracticeRecord::Status::SUBMITTED
    )
  end


  def check_by_user(user)
    practice_record = _get_record_by_user(user)

    practice_record.status = PracticeRecord::Status::CHECKED
    practice_record.checked_at = Time.now
    practice_record.save
  end


  def in_submitted_status_of_user?(user)
    return false if _empty_records_by_user?(user)
    _get_record_by_user(user).status == PracticeRecord::Status::SUBMITTED
  end

  def in_checked_status_of_user?(user)
    return false if _empty_records_by_user?(user)
    _get_record_by_user(user).status == PracticeRecord::Status::CHECKED
  end

  def submitted_time_by_user(user)
    _get_record_by_user(user).submitted_at
  end

  def checked_time_by_user(user)
    _get_record_by_user(user).checked_at
  end

  private
    def _empty_records_by_user?(user)
      self.records.where(:user_id => user.id).count == 0
    end

    def _get_record_by_user(user)    
      self.records.where(:user_id => user.id).first
    end


  module UserMethods
    def self.included(base)
      base.has_many :practices, :class_name => 'Practice', :foreign_key => :creator_id
    end
  end

end
