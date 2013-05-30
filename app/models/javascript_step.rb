# -*- coding: utf-8 -*-
class JavascriptStep < ActiveRecord::Base
  belongs_to :course_ware

  validates :course_ware, :content, :rule,
            :presence => true

  
end