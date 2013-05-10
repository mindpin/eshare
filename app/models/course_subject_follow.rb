class CourseSubjectFollow < ActiveRecord::Base
  attr_accessible :course_subject, :user

  belongs_to :course_subject
  belongs_to :user

  validate :course_subject, :presence => true
  validate :user,           :presence => true

  scope :by_user, lambda{|user| {:conditions => ['user_id = ?', user.id]} }

  module UserMethods
    def self.included(base)
      base.has_many :course_subject_follows
      base.has_many :follow_course_subjects, :through => :course_subject_follows, :source => :course_subject
    end
  end

  module CourseSubjectMethods
    def self.included(base)
      base.has_many :course_subject_follows
      base.has_many :follow_users, :through => :course_subject_follows, :source => :user
    end

    def follow_by_user(user)
      self.course_subject_follows.create(:user => user) if !self.is_follow?(user)
    end

    def unfollow_by_user(user)
      self.course_subject_follows.by_user(user).destroy_all
    end

    def is_follow?(user)
      self.follow_users.include?(user)
    end
  end

end