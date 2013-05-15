class SelectCourseApply < ActiveRecord::Base
  STATUS_REQUEST  = "REQUEST" # 提出选课请求
  STATUS_ACCEPT   = "ACCEPT"  # 批准
  STATUS_REJECT   = "REJECT"  # 拒绝

  attr_accessible :course, :user, :status

  belongs_to :course
  belongs_to :user

  validates :course, :user, :presence => true
  validates :user_id,  :uniqueness => {:scope => :course_id}

  validates :status, :inclusion => [STATUS_REQUEST, STATUS_ACCEPT, STATUS_REJECT]

  scope :by_status, lambda{|status| {:conditions => ['status = ?', status]} }
  scope :by_course, lambda{|course| {:conditions => ['course_id = ?', course.id]} }

  module CourseMethods
    def self.included(base)
      base.has_many :select_course_applies
      base.has_many :apply_users, :through => :select_course_applies, :source => :user
    end

    # 8 查询一个课程的所有”没有处理“的选课请求(status == REQUEST)
    def request_select_course_applies
      self.select_course_applies.by_status(STATUS_REQUEST)
    end

    # 6 查询课程被哪些用户“选中”（status == ACCEPT 的情况）
    def selected_users
      _apply_users_by_status(STATUS_ACCEPT)
    end

    # 5 查询课程被哪些用户“选了”（status == REQUEST 的情况）
    def apply_select_users
      _apply_users_by_status(STATUS_REQUEST)
    end

    # 4 判断一个用户是否"选中"某门课（status == ACCEPT 的情况）
    def is_selected?(user)
      user.selected_courses.include?(self)
    end

    #3 判断一个用户是否“选了”某门课（status == REQUEST 的情况）
    def is_apply_select?(user)
      user.apply_select_courses.include?(self)
    end

    private
      def _apply_users_by_status(status)
        self.apply_users.where('select_course_applies.status = ?', status)
      end
  end

  module UserMethods
    def self.included(base)
      base.has_many :select_course_applies
      base.has_many :apply_courses, :through => :select_course_applies, :source => :course
    end

    # 7 用户发起一个选课请求
    def select_course(course)
      return if course.is_apply_select?(self) || course.is_selected?(self)
      if self.apply_courses.include?(course)
        self.select_course_applies.by_course(course).first.update_attributes :status => STATUS_REQUEST
      else
        self.select_course_applies.create(:course => course, :status => STATUS_REQUEST)
      end
    end

    # 2 查询用户“选中”的课程列表（status == ACCEPT 的情况）
    def selected_courses
      _apply_courses_by_status(STATUS_ACCEPT)
    end

    # 1 查询用户"选了"的课程列表（status == REQUEST 的情况）
    def apply_select_courses
      _apply_courses_by_status(STATUS_REQUEST)
    end

    private
      def _apply_courses_by_status(status)
        self.apply_courses.where(
          'select_course_applies.status = ?', status
        )
      end
  end

end