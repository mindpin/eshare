class MediaResourceCreatedTip
  MATCH_NOTHING = 'MATCH_NOTHING'
  MATCH_CATEGORY_NAME = 'MATCH_CATEGORY_NAME'
  MATCH_PUBLIC_RESOURCE_NAME = 'MATCH_PUBLIC_RESOURCE_NAME'

  attr_reader :kind, :info
  def initialize(kind, info)
    @kind = kind
    @info = info
  end

  def self.build(media_resource)
    tips = []

    tips << _build_match_category_name(media_resource)
    tips << _build_match_public_resource_name(media_resource)

    tips = tips.compact

    return tips if tips.present?

    [MediaResourceCreatedTip.new(MATCH_NOTHING,{})]
  end

  private

  def self._build_match_public_resource_name(media_resource)
    media_resources = MediaResource.publics.by_name(media_resource.name)
    media_resources = media_resources - [media_resource]
    return if media_resources.blank?

    MediaResourceCreatedTip.new(MATCH_PUBLIC_RESOURCE_NAME, {:media_resources => media_resources})
  end

  def self._build_match_category_name(media_resource)
    basename = self._basename(media_resource)

    categories = Category.by_name(basename)
    return if categories.blank?

    MediaResourceCreatedTip.new(MATCH_CATEGORY_NAME, {:categories => categories})
  end

  def self._basename(media_resource)
    ext = File.extname(media_resource.name)
    File.basename(media_resource.name, ext)
  end
end