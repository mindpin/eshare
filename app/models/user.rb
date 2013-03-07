# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
  include UserAvatarMethods
  include UserAuthMethods
  # admin 模块
  include Student::UserMethods
  include Teacher::UserMethods

  # 在线状态记录
  has_one :online_record,:dependent => :destroy
  # 校验部分
  # 不能为空的有：用户名，登录名，电子邮箱
  # 不能重复的有：登录名，电子邮箱（大小写不区分）
  # 两次密码输入必须一样，电子邮箱格式必须正确
  # 密码允许为空，但是如果输入了，就必须是4-32
  # 用户名：是2-20位的中文或者英文，可以混写
  validates :email,
    :presence => true,
    :uniqueness => { :case_sensitive => false },
    :format => /^([A-Za-z0-9_]+)([\.\-\+][A-Za-z0-9_]+)*(\@[A-Za-z0-9_]+)([\.\-][A-Za-z0-9_]+)*(\.[A-Za-z0-9_]+)$/

  validates :name, 
    :presence => true,
    :length => 2..20,
    :uniqueness => { :case_sensitive => false },
    :format => /^([A-Za-z0-9一-龥]+)$/

  validates :password,
    :presence => { :on => :create },
    :confirmation => true,
    :length => { :in => 4..32 , :on => :create}

  ROLES = %w[admin student teacher]
  scope :with_role, lambda { |role| {:conditions => "roles_mask & #{2**ROLES.index(role.to_s)} > 0"} }

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end

  def roles
    ROLES.reject { |r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }
  end

  def role?(role)
    roles.include? role.to_s
  end

  def set_role(role)
    self.roles = (ROLES & [role.to_s])
    save
  end

  def is_admin?
    role? "admin"
  end

  def real_name
    return self.name if self.is_admin?
    teacher_or_student_real_name if is_teacher_or_student?
  end

  def title_str
    "#{self.real_name}#{self.is_student? ? '同学' : '老师'}"
  end

  def role_str
    return '学生' if self.is_student?
    '教师'
  end


private

  def teacher_or_student_real_name
    (self.student && self.student.real_name) ||
    (self.teacher && self.teacher.real_name)
  end

  def is_teacher_or_student?
    self.is_teacher? || self.is_student?
  end
end
