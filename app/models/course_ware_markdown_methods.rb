module CourseWareMarkdownMethods
  IMAGE_REGEX = /!\[\S+\]\((\S+)(\s+\"\S+\")?\)/
  def self.included(base)
    base.before_save :build_markdown_file_entity
  end

  def markdown=(markdown)
    @markdown = markdown
  end

  def markdown(options = {})
    if new_record?
      content = @markdown || ""
    else
      content = @markdown || (
        File.open(self.file_entity.attach.path).read
      )
    end

    bool_replace = !!options[:replace_outer_url]
    if bool_replace
      content = content.gsub(IMAGE_REGEX) do |match|
        entity = FileEntity.get_outer_image($1)
        match.gsub($1, entity.url)
      end
    end
    content
  end

  def build_markdown_file_entity
    return true if @markdown.blank?

    _process_outer_image_url_for_markdown
    if !self.file_entity.blank?
      old_content = File.open(self.file_entity.attach.path).read
      return true if old_content == @markdown
    end

    file = Tempfile.new(['content', '.md'])
    file.write(@markdown)
    file.rewind
    self.file_entity = FileEntity.create!(:attach => file)
    self.kind = 'markdown'
    file.unlink
    return true
  end

  def _process_outer_image_url_for_markdown
    matchs = @markdown.gsub(IMAGE_REGEX)
    matchs.each do |match|
      FileEntity.get_outer_image(match)
    end
  end

end