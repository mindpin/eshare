# -*- coding: utf-8 -*-
class CourseCollectItem < ActiveRecord::Base

  attr_accessible :course_collect, :course, :comment

  belongs_to :course_collect
  belongs_to :course

  validates :course_collect, :course, :presence => true
end