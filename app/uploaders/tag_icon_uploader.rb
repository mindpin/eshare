class TagIconUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include ImageUploaderMethods

  storage :file

  def default_url
    "/assets/default_icon/#{version_name}.png"
  end

  version :large do
    process :resize_to_fill => [180, 180]
  end
  version :normal do
    process :resize_to_fill => [64, 64]
  end
  version :small do
    process :resize_to_fill => [30, 30]
  end
end
