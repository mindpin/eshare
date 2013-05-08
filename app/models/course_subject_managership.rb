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
      errors.add :base, '不能把主管理员设置为副管理员'
    end
  end

  module CourseSubjectMethods
    def self.included(base)
      base.has_many :course_subject_managerships
      base.has_many :secondary_managers, :through => :course_subject_managerships, :source => :user
    end

    def add_manager(user)
      self.course_subject_managerships.create(:user => user)
    end

    def remove_manager(user)
      self.course_subject_managerships.by_user(user).destroy_all
    end
  end

  module UserMethods
    def self.included(base)
      base.has_many :course_subject_managerships
       # user作为副管理员的课程主题
      base.has_many :manage_course_subjects, :through => :course_subject_managerships, :source => :course_subject
    end
  end
end