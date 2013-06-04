# -*- coding: utf-8 -*-
class CssStep < ActiveRecord::Base
  attr_accessible :course_ware, :content, :rule

  belongs_to :course_ware

  validates :course_ware, :content, :rule,
            :presence => true

  default_scope order('id asc')

  scope :by_course_ware, lambda{|course_ware| {:conditions => ['course_ware_id = ?', course_ware.id]} }

  after_create  :set_course_ware_total_count
  after_destroy :set_course_ware_total_count
  def set_course_ware_total_count
    count = course_ware.css_steps.count
    course_ware.update_attributes(:total_count => count)
  end

  def prev
    self.class.by_course_ware(course_ware).where('id < ?', self.id).last
  end

  def next
    self.class.by_course_ware(course_ware).where('id > ?', self.id).first
  end

  include StepHistory::StepMethods
end