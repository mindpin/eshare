class FileEntity < ActiveRecord::Base
  file_part_upload

  validates :attach_file_name, :presence => true, :if => :upload_file_blank?
  validates :attach_file_size, :presence => true, :if => :upload_file_blank?
  validates :saved_size, :presence => true, :if => :upload_file_blank?

  # will be fixed on Issue #8
  def upload_file_blank?
    @upload_file.blank?
  end

  # will be fixed on Issue #9
  before_validation :set_default_saved_size
  def set_default_saved_size
    self.saved_size = 0 if self.saved_size.blank?
  end

  CONTENT_TYPES = {
    :video    => [
        'avi', 'rm',  'rmvb', 'mp4', 
        'ogv', 'm4v', 'flv', 'mpeg',
        '3gp'
      ].map{|x| file_content_type(x)}.uniq - ['application/octet-stream'],
    :audio    => [
        'mp3', 'wma', 'm4a',  'wav', 
        'ogg'
      ].map{|x| file_content_type(x)}.uniq,
    :image    => [
        'jpg', 'jpeg', 'bmp', 'png', 
        'png', 'svg',  'tif', 'gif'
      ].map{|x| file_content_type(x)}.uniq,
    :document => [
        'pdf', 'xls', 'doc', 'ppt', 
        'txt'
      ].map{|x| file_content_type(x)}.uniq,
    :swf => ['swf'].map{|x| file_content_type(x)}.uniq
  }

  has_many :media_resources

  def self.content_kind(type)
    case type
    when *CONTENT_TYPES[:video]
      :video
    when *CONTENT_TYPES[:audio]
      :audio
    when *CONTENT_TYPES[:image]
      :image
    when *CONTENT_TYPES[:document]
      :document
    when *CONTENT_TYPES[:swf]
      :swf
    end
  end

    # 获取资源种类
  def content_kind
    self.class.content_kind(self.attach_content_type)
  end

  def is_video?
    :video == self.content_kind
  end

  def is_audio?
    :audio == self.content_kind
  end

  def is_image?
    :image == self.content_kind
  end


end

