# -*- coding: utf-8 -*-
class CourseCollect < ActiveRecord::Base

  attr_accessible :user, :title, :desc

  belongs_to :user

  validates :user, :title, :desc, :presence => true
end