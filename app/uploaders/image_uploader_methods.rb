module ImageUploaderMethods
  # 给上传的文件重新命名
  def filename
    if original_filename.present?
      ext = file.extension.blank? ? '' : ".#{file.extension}"
      "#{secure_token}#{ext}"
    end
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # 允许上传的文件类型的扩展名
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  private
    def secure_token
      var = :"@#{mounted_as}_secure_token"
      model.instance_variable_get(var) || model.instance_variable_set(var, randstr)
    end
end