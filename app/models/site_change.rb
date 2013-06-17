# -*- coding: utf-8 -*-
class SiteChange < ActiveRecord::Base
  attr_accessible :content

  validates :content, :presence => true
end