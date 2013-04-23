# -*- coding: utf-8 -*-
class MediaResource < ActiveRecord::Base
  include ModelRemovable # add scope
  include MediaResourceDynatreeMethods
  include MediaResourceInfosMethods
  include MediaResourceCrudMethods
  include MediaResourceCategoryMethods
  include MediaResourceTipMethods
  include MediaShare::MediaResourceMethods
  simple_taggable

  attr_accessible :name,
                  :is_dir,
                  :creator,
                  :media_resources,
                  :file_entity,
                  :is_removed


  belongs_to :file_entity

  belongs_to :creator, :class_name  => 'User',
                       :foreign_key => 'creator_id'

  belongs_to :dir, :class_name  => 'MediaResource',
                   :foreign_key => 'dir_id',
                   :conditions  => {:is_dir => true}

  has_many   :media_resources, :foreign_key => 'dir_id',
                               :order => "name asc"

  validates  :creator, :presence => true

  validates  :name, :uniqueness => {
                      :case_sensitive => false,
                      :scope => [:dir_id, :creator_id]
                    }

  validate do
    if !self.is_on_root?
      # dir_id 关联的资源必须是目录
      parent_dir = self.dir
      if parent_dir.blank? || parent_dir.is_file?
        self.errors.add :dir, '资源的父资源必须是一个目录'
      end
    end
  end

  validate do
    if self.dir.present?
      media_resource = self.dir.media_resources.where(:name => self.name).first
      if media_resource.present? && media_resource != self
        self.errors.add(:dir, '不允许同名文件被保存在同一文件夹下')
      end
    end
  end

  # --------

  before_create :create_fileops_time
  def create_fileops_time
    self.fileops_time = Time.now
  end

  before_create :update_parent_dirs_files_count
  def update_parent_dirs_files_count
    return true if self.is_dir?

    parent_dir = self.dir
    while parent_dir.present? do
      parent_dir.increment!(:files_count, 1)
      parent_dir = parent_dir.dir
    end
    return true
  end

  # --------
  scope :by_name, lambda{|name|{:conditions=>['name =?', name]}}
  scope :dir_res, :conditions => ['is_dir = ?', true]
  scope :root_res, :conditions => ['dir_id = ?', 0]
  scope :ops_order, order('fileops_time ASC')
  scope :web_order, order('is_dir DESC, name ASC')
  scope :of_creator, lambda{|user| where(:creator_id => user.id)}
  scope :with_tag_name, lambda {|tag_name|
    joins("inner join taggings on taggings.taggable_type = 'MediaResource' and taggings.taggable_id = media_resources.id").
    joins("inner join tags on tags.id = taggings.tag_id").
    where("tags.name = '#{tag_name}'")
  }

  # --------

  def self.delta(creator, cursor, limit = 100)
    with_exclusive_scope do
      delta_media_resources = creator.media_resources.where('fileops_time > ?', cursor || 0).limit(limit)

      if delta_media_resources.blank?
        new_cursor = cursor
        has_more   = false
      else
        last_fileops_time = delta_media_resources.last.fileops_time
        new_cursor = last_fileops_time
        has_more   = last_fileops_time < MediaResource.last.fileops_time
      end

      entries = delta_media_resources.map do |r|
        [r.path, r.is_removed? ? nil : r.metadata(:list => false)]
      end

      return {
        :entries  => entries,
        :reset    => false,
        :cursor   => new_cursor,
        :has_more => has_more
      }
    end
  end
  
  class InvalidPathError < Exception; end
  class RepeatedlyCreateFolderError < Exception; end
  class NotAssignCreatorError < Exception; end
  class FileEmptyError < Exception; end
  class NotDirError < Exception; end

  class RootDir
    def self.media_resources
      MediaResource.root_res
    end
  end

  module UserMethods
    extend ActiveSupport::Concern

    included do
      has_many :media_resources, :foreign_key => 'creator_id'
    end
  end

end
