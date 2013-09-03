module MarkdownImageRegexMethods
  IMAGE_REGEX = /!\[\S+\]\((\S+)(\s+\"\S+\")?\)/

  def build_outer_image_file_entity(content)
    matchs = content.gsub(IMAGE_REGEX)
    matchs.each do |match|
      FileEntity.get_outer_image(match)
    end
  end

  def get_replace_outer_image_url(content)
    content.gsub(IMAGE_REGEX) do |match|
      entity = FileEntity.get_outer_image($1)
      match.gsub($1, entity.url)
    end
  end
end
