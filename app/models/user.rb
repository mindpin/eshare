# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  # :recoverable
  devise :database_authenticatable, :registerable, 
         :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

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

  # 修改基本信息
  attr_accessible :login, :name, :email, :as => :change_base_info
  # 修改密码
  attr_accessible :password, :password_confirmation, :as => :change_password

  # MediaResource
  include MediaResource::UserMethods

  # carrierwave
  mount_uploader :avatar, AvatarUploader
  attr_accessible :name, :avatar

  # 声明角色
  attr_accessible :role
  validates :role, :presence => true
  roles_field :roles_mask, :roles => [:admin, :manager, :teacher, :student]

  # 分别为学生和老师增加动态字段
  include DynamicAttr::Owner
  has_dynamic_attrs :student_attrs,
                    :updater => lambda {AttrsConfig.get(:student)}
  has_dynamic_attrs :teacher_attrs,
                    :updater => lambda {AttrsConfig.get(:teacher)}

  # 导入文件
  simple_excel_import :teacher, :fields => [:login, :name, :email, :password],
                                :default => {:role => :teacher}

  simple_excel_import :student, :fields => [:login, :name, :email, :password],
                                :default => {:role => :student}

  include Course::UserMethods

  include Homework::UserMethods
  include Question::UserMethods
  include Answer::UserMethods
  include AnswerVote::UserMethods
  include Announcement::UserMethods
  include Survey::UserMethods
  include Follow::UserMethods
  include UserFeedStream
end
