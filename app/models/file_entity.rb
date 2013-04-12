# -*- coding: utf-8 -*-
class FileEntity < ActiveRecord::Base
  include FileEntityConvertMethods

  if Rails.env == 'test'
    file_part_upload :path => 'files/test/:class/:id/:name'
  else
    file_part_upload :path => 'files/:class/:id/:name'
  end

  EXTNAME_HASH = {
    :video => [
      'avi', 'rm',  'rmvb', 'mp4', 
      'ogv', 'm4v', 'flv', 'mpeg',
      '3gp'
    ],
    :audio => [
      'mp3', 'wma', 'm4a',  'wav', 
      'ogg'
    ],
    :image => [
      'jpg', 'jpeg', 'bmp', 'png', 
      'png', 'svg',  'tif', 'gif'
    ],
    :document => [
      'pdf', 'xls', 'doc', 'txt'
    ],
    :swf => [
      'swf'
    ],
    :ppt => [
      'ppt'
    ]
  }

  has_many :media_resources

  # 获取资源种类
  def extname
    File.extname(self.attach_file_name).downcase.sub('.', '')
  end

  def content_kind
    EXTNAME_HASH.each do |key, value|
      return key if value.include?(extname)
    end
    return nil
  end

  EXTNAME_HASH.each do |key, value|
    define_method "is_#{key}?" do
      key == self.content_kind
    end
  end
end

