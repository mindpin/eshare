# -*- coding: utf-8 -*-
class EnvironmentConfigState < ActiveRecord::Base
  attr_accessible :title, :content, :course_ware

  belongs_to :course_ware

  validates :course_ware, :title, :content,
            :presence => true


  module CourseWareMethods
    def self.included(base)
      base.has_many :environment_config_states
    end
  end

end