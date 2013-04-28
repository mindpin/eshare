# -*- coding: utf-8 -*-
class CourseWare < ActiveRecord::Base
  include AnswerCourseWare::CourseWareMethods
  include CourseWareReadingModule
  include CourseWareMarkModule
  include MovePosition::ModelMethods
  include CourseReadPercent::CourseWareMethods
  include CourseWareKindMethods
  include CourseWareReadingDelta::CourseWareMethods

  attr_accessible :title, :desc, :url, :creator, :total_count
  attr_accessible :title, :desc, :file_entity_id, :kind, :url, :as => :upload
  attr_accessible :cover_url_cache, :as => :update_cover

  validates :title, :chapter, :creator,
            :presence => true
            
  belongs_to :chapter
  belongs_to :creator, :class_name => 'User'
  belongs_to :file_entity
  belongs_to :media_resource
  has_many :course_ware_readings
  has_many :course_ware_marks
  has_many :questions, :as => :model

  scope :by_course, lambda {|course|
    joins(:chapter).where('chapters.course_id = ?', course.id)
  }

  scope :read_with_user, lambda {|user|
    joins(:course_ware_readings).where(%`
      course_ware_readings.read is true
        and
      course_ware_readings.user_id = #{user.id}
    `)
  }

  scope :by_chapter, lambda{|chapter| {:conditions => ['chapter_id = ?', chapter.id]} }

  before_save :process_media_resource
  def process_media_resource
    return true if file_entity.blank?

    if media_resource.blank? || media_resource.file_entity != file_entity

      path = "/课件/#{chapter.course.name}/#{file_entity.attach_file_name}"

      resource = MediaResource.put_file_entity(creator, path, file_entity)
      kind = file_entity.content_kind
      
      self.kind = kind
      self.media_resource = resource
    end
  end

  before_save :set_total_count_by_kind!
  def set_total_count_by_kind!
    self.total_count = 1000 if self.is_video?
    self.total_count = 0 if self.total_count.blank?
  end

  # 修改后，需要重置 total_count 和 cover
  before_update :refresh_cover_and_total_count
  def refresh_cover_and_total_count
    if self.file_entity_id_changed? || self.kind_changed? || self.url_changed?
      self.set_total_count_by_kind!
      self.cover_url_cache = nil
    end
    return true
  end

  # 刷新 total_count 值。此方法在 controller中被调用
  def refresh_total_count!
    self.total_count = _get_total_count_by_kind
    self.save if self.total_count_changed?
  end

  def _get_total_count_by_kind
    return 1000 if self.is_video?

    if file_entity.present? && convert_success?
      return file_entity.output_images.count if file_entity.is_pdf?
      return file_entity.output_images.count if file_entity.is_ppt?
    end

    return 0
  end

  def convert_status
    return '' if file_entity.blank?
    return file_entity.convert_status
  end

  # 尝试给关联的资源进行转码
  def do_convert_file_entity(force = false)
    return if file_entity.blank?
    file_entity.do_convert(force)
  end

  delegate :convert_success?, :to => :file_entity
  delegate :converting?,      :to => :file_entity
  delegate :convert_failure?, :to => :file_entity
  delegate :output_images,    :to => :file_entity

  def cover_url
    return cover_url_cache if cover_url_cache.present?

    if is_youku?
      cover_url = self.youku_video.video_cover_url
    end

    self.update_attributes({ :cover_url_cache => cover_url }, :as => :update_cover)
    return cover_url
  end

  # -----------
  # 排序相关

  def prev
    chapter.course_wares.where('position < ?', position).last
  end

  def next
    chapter.course_wares.where('position > ?', position).first
  end

end
