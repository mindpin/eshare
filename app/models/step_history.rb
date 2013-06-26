class StepHistory < ActiveRecord::Base
  attr_accessible :user, :course_ware, :step, :input, :is_passed

  belongs_to :user
  belongs_to :course_ware
  belongs_to :step, :polymorphic => true

  validates :user, :course_ware, :step, :input, :presence => true
  scope :by_user, lambda{|user| {:conditions => ['step_histories.user_id = ?', user.id] } }
  scope :passed,  :conditions => ['step_histories.is_passed IS TRUE']
  scope :unpassed, :conditions => ['step_histories.is_passed IS NOT TRUE']

  before_validation :set_course_ware
  def set_course_ware
    if self.step.present? && self.course_ware.blank?
      self.course_ware = self.step.course_ware
    end
  end

  after_create :refresh_course_ware_reading
  def refresh_course_ware_reading
    count = self.course_ware.passed_step_count_of(self.user)
    self.course_ware.update_read_count_by(self.user, count)
  end

  module StepMethods
    def self.included(base)
      base.has_many :step_histories, :as => :step
      base.has_many :passed_users, :through => :step_histories, :source => :user,
        :conditions => 'step_histories.is_passed IS TRUE', :uniq => true
      base.has_many :tried_users, :through => :step_histories, :source => :user,
        :uniq => true
    end

    def is_passed_by?(user)
      return false if user.blank?
      
      self.step_histories.by_user(user).passed.present?
    end

    def pass_status_of(user)
      return '' if user.blank?

      return 'done' if is_passed_by?(user)
      return 'error' if self.step_histories.by_user(user).unpassed.present?
      return ''
    end

    def unpassed_users
      tried_users - passed_users
    end
    
    def record_input(user, input, passed)
      # 如果已经通过，则不再记录更多错误输入
      return if self.is_passed_by?(user) && passed == false

      self.step_histories.create({
        :user => user,  
        :input => input,
        :is_passed => passed
      })
    end
  end

  module CourseWareMethods
    def self.included(base)
      base.has_many :step_histories
    end

    def passed_step_count_of(user)
      return 0 if user.blank?
      self.step_histories.by_user(user).passed.map{|history|history.step}.uniq.count
    end

    def is_passed_by?(user)
      return false if user.blank?
      passed_step_count_of(user) == self.total_count
    end
  end
end
