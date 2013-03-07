# -*- coding: utf-8 -*-
class Student < ActiveRecord::Base
  attr_accessible :real_name, :sid, :user_id, :user, :is_removed, :user_attributes
  include Pacecar
  include ModelRemovable
  include Paginated

  class ATTACHMENT
    KIND_JIU_YE_XIE_YI = "jiu_ye_xie_yi"
    KIND_BI_YE_JIAN_DING = "bi_ye_jian_ding"
  end

  belongs_to :user

  belongs_to :jiu_ye_xie_yi, 
    :class_name => "FileEntity", :foreign_key => :jiu_ye_xie_yi_file_entity_id

  belongs_to :bi_ye_jian_ding, 
    :class_name => "FileEntity", :foreign_key => :bi_ye_jian_ding_file_entity_id

  scope :no_team, joins('left join team_students on team_students.student_user_id = students.user_id').where('team_students.team_id is null')
  scope :of_team,lambda{|team|joins("inner join team_students on team_students.student_user_id = students.user_id").where("team_students.team_id = #{team.id}")}

  scope :with_teacher, lambda {|teacher_user|
    joins('inner join course_student_assigns on course_student_assigns.student_user_id = students.user_id').where('course_student_assigns.teacher_user_id = ?', teacher_user.id).group('students.user_id')
  }

  scope :with_semester, lambda {|semester|
    joins('inner join course_student_assigns on course_student_assigns.student_user_id = students.user_id').where('course_student_assigns.semester_value = ?', semester.value).group('students.user_id')
  }

  # --- 校验方法
  validates :real_name, :presence => true
  validates :sid, :uniqueness => { :if => Proc.new { |student| !student.sid.blank? } }
  validates :user, :presence => true

  validate do |student|
    if !student.user_id.blank?
      students = Student.find_all_by_user_id(student.user_id)
      teachers = Teacher.find_all_by_user_id(student.user_id)
      other_students = students-[student]
      if !other_students.blank? || !teachers.blank?
        errors.add(:user, "该用户账号已经被其他教师或者学生绑定")
      end
    end
  end

  accepts_nested_attributes_for :user

  after_save :set_student_role

  # after_save :destroy_homework_assigns_after_remove
  # def destroy_homework_assigns_after_remove
  #   self.user.homework_assigns.destroy_all if self.is_removed?
  # end

  # after_save :destroy_team_student_after_remove
  # def destroy_team_student_after_remove
  #   if self.is_removed?
  #     team_student = self.user.team_student
  #     team_student.destroy if !team_student.blank?
  #   end
  # end

  after_update :change_datetime_to_date
  def change_datetime_to_date
  end

  def destroyable_by?(user)
    user.is_admin?
  end

  def self.import_from_csv(file)
    ActiveRecord::Base.transaction do
      parse_csv_file(file) do |row,index|
        student = Student.new(
          :real_name => row[0], :sid => row[1],
          :user_attributes => {
            :name => row[2],
            :email => row[3],
            :password => row[4],
            :password_confirmation => row[4]
          })
        if !student.save
          message = student.errors.first[1]
          raise "第 #{index+1} 行解析出错,可能的错误原因 #{message} ,请修改后重新导入"
        end
      end
    end
  end

  def save_attachment(kind,file_entity)
    case kind
    when Student::ATTACHMENT::KIND_BI_YE_JIAN_DING
      self.update_attributes :bi_ye_jian_ding => file_entity
    when Student::ATTACHMENT::KIND_JIU_YE_XIE_YI
      self.update_attributes :jiu_ye_xie_yi => file_entity
    end
  end

  def team_name
    team = user.student_team 
    return "无" if team.blank?
    team.name
  end

private

  def set_student_role
    self.user.set_role :student
  end

  module UserMethods
    def self.included(base)
      base.has_one :student
      base.send(:include,InstanceMethod)
    end
    
    module InstanceMethod
      def is_student?
        role? "student"
      end

    end
  end

end
