# -*- coding: utf-8 -*-
class CourseWare < ActiveRecord::Base
  attr_accessible :title, :desc, :url, :creator

  validates :title, :chapter, :creator,
            :presence => true
            
  belongs_to :chapter
  belongs_to :creator, :class_name => 'User'
  belongs_to :file_entity

  def kind
    kind = read_attribute("kind")
    kind.blank? ? kind : kind.to_sym 
  end

  def link_file_entity(file_entity)
    kind = file_entity.content_kind
    self.kind = kind
    self.file_entity = file_entity
    self.save

    chapter = self.chapter
    course = chapter.course
    path = "/课件/#{course.name}/#{file_entity.attach_file_name}"

    MediaResource.put_file_entity(self.creator, path, file_entity)
  end

  def url=(input)
    self.kind = 'youku'
    write_attribute :url, input.match(/id_(\w*)\.html/)[1]
  end

  def url
    "http://player.youku.com/embed/#{read_attribute :url}" if self.youku?
  end

  def youku?
    self.kind == 'youku'
  end
end
