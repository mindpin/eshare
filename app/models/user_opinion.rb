# -*- coding: utf-8 -*-
class UserOpinion < ActiveRecord::Base
  attr_accessible :title, :content, :contact, :image

  belongs_to :user

  validates :title, :content, :contact, :presence => true

  # carrierwave
  mount_uploader :image, UserOpinionUploader
end