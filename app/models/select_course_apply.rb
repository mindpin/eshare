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

  def self.course_status_stat
    sql = %~
      SELECT C.id, C.name, C.apply_request_limit, count(SCA.id) AS CO FROM courses AS C
      LEFT JOIN select_course_applies AS SCA 
      ON SCA.course_id = C.id
      GROUP BY C.id
    ~

    re = Course.find_by_sql sql

    stat = {
      :notfull => 0, :full => 0, :over => 0, :empty => 0
    }

    re.map { |x|
      limit = x[:apply_request_limit]
      count = x[:CO]

      if count == 0
        stat[:empty] = stat[:empty] + 1 
        next
      end

      if limit == -1
        stat[:notfull] = stat[:notfull] + 1 
        next
      end

      stat[:notfull] = stat[:notfull] + 1 if limit > count 
      stat[:full] = stat[:full] + 1 if limit == count 
      stat[:over] = stat[:over] + 1 if limit < count 
    }

    stat
  end

  def self._subsql
    %~
      SELECT C.*, C.apply_request_limit AS LIM, count(SCA.id) AS CO FROM courses AS C
      LEFT JOIN select_course_applies AS SCA 
      ON SCA.course_id = C.id
      GROUP BY C.id
    ~
  end

  def self.empty_courses
    Course.from("(#{self._subsql}) AS courses").where("courses.CO = 0")
  end

  def self.over_courses
    Course.from("(#{self._subsql}) AS courses").where("courses.CO > courses.LIM AND courses.LIM <> -1")
  end

  def self.full_courses
    Course.from("(#{self._subsql}) AS courses").where("courses.CO = courses.LIM AND courses.LIM <> -1")
  end

  def self.notfull_courses
    Course.from("(#{self._subsql}) AS courses").where("(courses.CO < courses.LIM OR courses.LIM = -1) AND (courses.CO <> 0)")
  end

  def self.select_apply_status_courses(label)
    return self.empty_courses if label == 'empty'
    return self.over_courses if label == 'over'
    return self.full_courses if label == 'full'
    return self.notfull_courses if label == 'notfull'
  end

  module CourseMethods
    def self.included(base)
      base.has_many :select_course_applies, :dependent => :delete_all
      base.has_many :apply_users, :through => :select_course_applies, :source => :user
    end

    # 判断一个用户是否“选了”某门课（status == REQUEST 的情况）
    def is_request_selected_by?(user)
      sca = user.select_course_applies.by_course(self).first
      return sca.present? && sca.status == STATUS_REQUEST
    end

    # 判断一个用户是否"选中"某门课（status == ACCEPT 的情况）
    def is_accept_selected_by?(user)
      sca = user.select_course_applies.by_course(self).first
      return sca.present? && sca.status == STATUS_ACCEPT
    end

    # 判断一个用户的选某门课的请求是否被拒绝（status == REJECT 的情况）
    def is_reject_selected_by?(user)
      sca = user.select_course_applies.by_course(self).first
      return sca.present? && sca.status == STATUS_REJECT
    end

    # ----------------

    # 查询一个课程的所有“没有被处理”的选课请求(status == REQUEST)
    def request_select_course_applies
      self.select_course_applies.by_status(STATUS_REQUEST)
    end

    # 查询课程被哪些用户“选了”（status == REQUEST 的情况）
    def request_selected_users
      _apply_users_by_status(STATUS_REQUEST)
    end

    # 查询课程被哪些用户“选中”（status == ACCEPT 的情况）
    def accept_selected_users
      _apply_users_by_status(STATUS_ACCEPT)
    end

    # 查询哪些用户的选课请求已被拒绝（status == REJECT 的情况）
    def reject_selected_users
      _apply_users_by_status(STATUS_REJECT)
    end

    # 是否有选课人数上限限制
    def have_apply_request_limit?
      self.apply_request_limit.present? && self.apply_request_limit > 0
    end

    # 查询是否已经到达选课人数上限
    def apply_request_is_full?
      return false if !self.have_apply_request_limit?
      return _requested_users_count >= self.apply_request_limit
    end

    # 查询现在还有多少选课名额
    def remaining_apply_request_count
      return -1 if !self.have_apply_request_limit?
      self.apply_request_limit - _requested_users_count
    end

    private
      def _requested_users_count
        self.request_selected_users.count + self.accept_selected_users.count
      end

      def _apply_users_by_status(status)
        self.apply_users.where('select_course_applies.status = ?', status)
      end
  end

  module UserMethods
    def self.included(base)
      base.has_many :select_course_applies
      base.has_many :apply_courses, :through => :select_course_applies, :source => :course
    end

    # 用户发起一个选课请求
    def select_course(course)
      return if self.apply_courses.include?(course)
      _prepare_course_apply_for(course).update_attributes :status => STATUS_REQUEST
    end

    # 查询用户"选了"的课程列表（status == REQUEST 的情况）
    def request_selected_courses
      _apply_courses_by_status(STATUS_REQUEST)
    end

    # 查询用户“选中”的课程列表（status == ACCEPT 的情况）
    def accept_selected_courses
      _apply_courses_by_status(STATUS_ACCEPT)
    end

    # 查询拒绝了该用户的课程列表（status == REJECT 的情况）
    def reject_selected_courses
      _apply_courses_by_status(STATUS_REJECT)
    end

    # 学生自己主动取消选择一门课程
    def cancel_select_course(course)
      return if !self.apply_courses.include?(course)
      self.select_course_applies.by_course(course).destroy_all
    end

    private
      def _prepare_course_apply_for(course)
        self.select_course_applies.by_course(course).first || 
        self.select_course_applies.build(:course => course)
      end

      def _apply_courses_by_status(status)
        self.apply_courses.where(
          'select_course_applies.status = ?', status
        )
      end
  end

end