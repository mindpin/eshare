class UserOpinionUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include ImageUploaderMethods

  # 存储方式 本地硬盘存储
  storage :file

  # 当文件不存在时的默认 url
  def default_url
    # For Rails 3.1+ asset pipeline compatibility:
    # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
    "/assets/default_user_opinions/#{version_name}.png"
  end

end