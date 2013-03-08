class User < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  # :recoverable
  devise :database_authenticatable, :registerable, 
         :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  attr_accessible :login
  validates :login, :format => {:with => /\A\w+\z/, :message => '只允许数字、字母和下划线'},
                    :length => {:in => 3..20},
                    :presence => true,
                    :uniqueness => {:case_sensitive => false}

  validates :email, :uniqueness => {:case_sensitive => false}

  def self.find_for_database_authentication(conditions)
    login = conditions.delete(:login)
    self.where(:login => login).first || self.where(:email => login).first
  end

  # ------------ 以上是用户登录相关代码，不要改动
  # ------------ 任何代码请在下方添加


  attr_accessible :logo, :name
  # admin 模块
  include Student::UserMethods
  include Teacher::UserMethods

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
