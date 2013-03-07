# -*- coding: utf-8 -*-
class Teacher < ActiveRecord::Base
  include ModelRemovable
  include Paginated
  include Pacecar
  
  belongs_to :user

  scope :with_student, lambda {|student_user|
    joins('inner join course_student_assigns on course_student_assigns.teacher_user_id = teachers.user_id').where('course_student_assigns.student_user_id = ?', student_user.id).group('teachers.id')
  }

  scope :with_semester, lambda {|semester|
    joins('inner join course_student_assigns on course_student_assigns.teacher_user_id = teachers.user_id').where('course_student_assigns.semester_value = ?', semester.value).group('teachers.id')
  }
  
  validates :real_name, :presence => true
  validates :tid, :uniqueness => { :if => Proc.new { |teacher| !teacher.tid.blank? } }
  validates :user, :presence => true
  validate do |teacher|
    if !teacher.user_id.blank?
      teachers = Teacher.find_all_by_user_id(teacher.user_id)
      students = Student.find_all_by_user_id(teacher.user_id)
      other_teachers = teachers-[teacher]
      if !other_teachers.blank? || !students.blank?
        errors.add(:user, "该用户账号已经被其他教师或者学生绑定")
      end
    end
  end

  accepts_nested_attributes_for :user
  
  after_save :set_teacher_role

  def destroyable_by?(user)
    user.is_admin?
  end

  def self.import_from_csv(file)
    ActiveRecord::Base.transaction do
      parse_csv_file(file) do |row,index|
        teacher = Teacher.new(
          :real_name => row[0], :tid => row[1],
          :user_attributes => {
            :name => row[2],
            :email => row[3],
            :password => row[4],
            :password_confirmation => row[4]
          })
        if !teacher.save
          message = teacher.errors.first[1]
          raise "第 #{index+1} 行解析出错,可能的错误原因 #{message} ,请修改后重新导入"
        end
      end
    end
  end

private

  def set_teacher_role
    self.user.set_role :teacher
  end

  module UserMethods
    def self.included(base)
      base.has_one :teacher
      base.send(:include,InstanceMethod)
    end
    
    module InstanceMethod
      def is_teacher?
        role? "teacher"
      end
      
    end
    
  end

end
