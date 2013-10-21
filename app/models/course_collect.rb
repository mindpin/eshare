# -*- coding: utf-8 -*-
class CourseCollect < ActiveRecord::Base

  attr_accessible :user, :title, :desc

  belongs_to :user
  has_many :course_collect_items

  validates :user, :title, :desc, :presence => true


  module UserMethods
    def self.included(base)
      base.has_many :course_collects
    end
  end

end