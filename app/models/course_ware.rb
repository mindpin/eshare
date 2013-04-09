# -*- coding: utf-8 -*-
class CourseWare < ActiveRecord::Base
  include AnswerCourseWare::CourseWareMethods

  attr_accessible :title, :desc, :url, :creator

  validates :title, :chapter, :creator,
            :presence => true
            
  belongs_to :chapter
  belongs_to :creator, :class_name => 'User'
  belongs_to :file_entity
  belongs_to :media_resource

  def link_file_entity(file_entity)
    path = "/课件/#{self.chapter.course.name}/#{file_entity.attach_file_name}"
    resource = MediaResource.put_file_entity(self.creator, path, file_entity)
    kind = file_entity.content_kind
    
    self.kind = kind
    self.file_entity = file_entity
    self.media_resource = resource
    self.save

    self
  end

  delegate :convert_success?, :to => :file_entity
  delegate :converting?, :to => :file_entity
  delegate :convert_failure?, :to => :file_entity
  delegate :ppt_images, :to => :file_entity

  FileEntity::EXTNAME_HASH.each do |key, value|
    delegate "is_#{key}?", :to => :file_entity
  end

  def is_web_video?
    ['youku'].include? self.kind
  end
end
