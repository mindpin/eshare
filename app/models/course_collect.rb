# -*- coding: utf-8 -*-
class CourseCollect < ActiveRecord::Base

  attr_accessible :creator, :title, :desc

  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  has_many :course_collect_items

  validates :creator, :title, :desc, :presence => true


  module UserMethods
    def self.included(base)
      base.has_many :created_course_collects, :class_name => 'User', :foreign_key => :creator_id
    end
  end

end