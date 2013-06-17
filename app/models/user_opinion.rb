# -*- coding: utf-8 -*-
class UserOpinion < ActiveRecord::Base
  attr_accessible :title, :content, :contact

  validates :title, :content, :contact, :presence => true
end