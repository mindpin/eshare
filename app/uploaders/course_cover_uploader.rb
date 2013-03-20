class CourseCoverUploader < CarrierWave::Uploader::Base
  # 存储方式 本地硬盘存储
  storage :file
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # 给上传的文件重新命名
  def filename
    if original_filename.present?
      ext = file.extension.blank? ? "" : ".#{file.extension}"
      "#{secure_token}#{ext}"
    end
  end

  # 当文件不存在时的默认 url
  def default_url
    # For Rails 3.1+ asset pipeline compatibility:
    # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
    "default_course_covers/#{version_name}.png"
  end

  # 允许上传的文件类型的扩展名
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # 切割图片
  include CarrierWave::MiniMagick

  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) || model.instance_variable_set(var, randstr)
  end
end