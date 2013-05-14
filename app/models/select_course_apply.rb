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
      base.extend ClassMethods 
    end

    module ClassMethods
      def by_status_and_user(status,user)
        Course.joins(:select_course_applies).where(
        'select_course_applies.status = ? AND select_course_applies.user_id = ?',status, user.id)
      end
    end

    # 8 查询一个课程的所有”没有处理“的选课请求(status == REQUEST)
    def request_select_course_applies
      self.select_course_applies.by_status(STATUS_REQUEST)
    end

    # 6 查询课程被哪些用户“选中”（status == ACCEPT 的情况）
    def selected_users
      User.by_status_and_course(STATUS_ACCEPT,self)
    end

    # 5 查询课程被哪些用户“选了”（status == REQUEST 的情况）
    def apply_select_users
      User.by_status_and_course(STATUS_REQUEST,self)
    end

    # 4 判断一个用户是否"选中"某门课（status == ACCEPT 的情况）
    def is_selected?(user)
      user.selected_courses.include?(self)
    end

    #3 判断一个用户是否“选了”某门课（status == REQUEST 的情况）
    def is_apply_select?(user)
      # user.apply_select_courses.include?(SelectCourseApply.find_by_course_id_and_user_id(self.id, user.id))
      user.apply_select_courses.include?(self)
    end
  end

  module UserMethods
    def self.included(base)
      base.has_many :select_course_applies
      base.extend ClassMethods
    end

    module ClassMethods
      def by_status_and_course(status,course)
        User.joins(:select_course_applies).where(
        'select_course_applies.status = ? AND select_course_applies.course_id = ?',status, course.id)
      end
    end

    # 7 用户发起一个选课请求
    def select_course(course)
      return if course.is_apply_select?(self) || course.is_selected?(self)
      if self.courses.include?(course)
        self.select_course_applies.by_course(course).first.update_attributes :status => STATUS_REQUEST
      else
        self.select_course_applies.create(:course => course, :status => STATUS_REQUEST)
      end
    end

    # 2 查询用户“选中”的课程列表（status == ACCEPT 的情况）
    def selected_courses
      Course.by_status_and_user(STATUS_ACCEPT,self)
    end

    # 1 查询用户"选了"的课程列表（status == REQUEST 的情况）
    def apply_select_courses
      Course.by_status_and_user(STATUS_REQUEST,self)
    end
  end

end