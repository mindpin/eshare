class CourseSubjectManagership < ActiveRecord::Base
  attr_accessible :course_subject, :user

  belongs_to :user
  belongs_to :course_subject

  validates :user, :course_subject, :presence => true
  validates :user_id, :uniqueness => {:scope => :course_subject_id}

  scope :by_user, lambda{|user| {:conditions => ['user_id = ?', user.id]} }

  validate :user_check

  def user_check
    if self.user_id == self.course_subject.creator_id
      errors.add :base, 'course_subject_managerships.user_id == course_subject.creator_id' 
    end
  end

  module CourseSubjectMethods
    def self.included(base)
      base.has_many :course_subject_managerships
      base.has_many :managers, :through => :course_subject_managerships, :source => :user
    end

    def add_manager(user)
      self.course_subject_managerships.create(:user => user)
    end

    def remove_manager(user)
      course_subject_managership = self.course_subject_managerships.by_user(user).first
      course_subject_managership.destroy if course_subject_managership
    end
  end

  module UserMethods
    def self.included(base)
      base.has_many :course_subject_managerships
       # user作为副管理员的课程主题
      base.has_many :course_subjects, :through => :course_subject_managerships
    end
  end
end