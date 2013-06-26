# -*- coding: utf-8 -*-
class SqlStep < ActiveRecord::Base
  attr_accessible :course_ware, :content, :rule

  belongs_to :course_ware

  validates :course_ware, :content, :rule,
            :presence => true

  default_scope order('id asc')

  scope :by_course_ware, lambda{|course_ware| {:conditions => ['course_ware_id = ?', course_ware.id]} }
  
  after_create  :set_course_ware_total_count
  after_destroy :set_course_ware_total_count
  def set_course_ware_total_count
    count = course_ware.sql_steps.count
    course_ware.update_attributes(:total_count => count)
  end

  def prev
    self.class.by_course_ware(course_ware).where('id < ?', self.id).last
  end

  def next
    self.class.by_course_ware(course_ware).where('id > ?', self.id).first
  end

  def run(input, user)
    db = _init_sandbox_db(user)
    begin
      rows = db.execute(input)
    rescue Exception => e
      exception = e.message
    end

    {:result => rows, :exception => exception, :input => input}
  end

  include StepHistory::StepMethods

  private
    def _init_sandbox_db(user)
      path = File.join(R::UPLOAD_BASE_PATH,'sqlite_dbs', "user_#{user.id}")
      FileUtils.mkdir_p(path) unless File.exists?(path)

      db_file_path = File.join(path, "#{user.id}.db")

      SQLite3::Database.new db_file_path
    end

  
end