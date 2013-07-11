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

  after_create :give_medal
  def give_medal
    user = self.user
    passed_count = StepHistory.passed_steps_count_of(user)

    _give_medal_by_count(passed_count, 1  , user, :PASS_1_CODING_STEP)
    _give_medal_by_count(passed_count, 10 , user, :PASS_10_CODING_STEP)
    _give_medal_by_count(passed_count, 25 , user, :PASS_25_CODING_STEP)
    _give_medal_by_count(passed_count, 50 , user, :PASS_50_CODING_STEP)
    _give_medal_by_count(passed_count, 100, user, :PASS_100_CODING_STEP)
  end

  def _give_medal_by_count(passed_count, count, user, medal_name)
    return if user.has_medal?(medal_name)
    if passed_count >= count
      Medal.get(medal_name).give_to(user)
    end
  end

  # 获取指定用户通过教学步骤的数量
  def self.passed_steps_count_of(user)
    StepHistory.by_user(user).passed.count('DISTINCT step_id, step_type')
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
      User.find_by_sql(%`
        SELECT 
            DISTINCT users.* 
        FROM 
            users
        INNER JOIN
            step_histories ON step_histories.user_id = users.id
        LEFT JOIN
            (
            SELECT 
                DISTINCT users.* 
            FROM 
                users
            INNER JOIN 
                step_histories on step_histories.user_id = users.id
            WHERE
                step_histories.is_passed is TRUE 
                AND 
                step_histories.step_id = #{self.id} 
                AND 
                step_histories.step_type = '#{self.class.name}'
            ) AS true_users
        ON true_users.id = users.id
        WHERE 
            true_users.id is NULL 
            AND
            step_histories.is_passed is FALSE
            AND
            step_histories.step_id = #{self.id}
            AND 
            step_histories.step_type = '#{self.class.name}' 
      `
      )
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

    def user_submitted_code(user)
      return nil if user.blank?
      last = self.step_histories.by_user(user).last()

      last.blank? ? nil : last.input
    end
  end

  module CourseWareMethods
    def self.included(base)
      base.has_many :step_histories
    end

    def passed_step_count_of(user)
      return 0 if user.blank?
      self.step_histories.by_user(user).passed.map do |history|
        history.step
      end.compact.uniq.count
    end

    def is_passed_by?(user)
      return false if user.blank?
      passed_step_count_of(user) == self.total_count
    end
  end
end
