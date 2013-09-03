module CourseWareMarkdownMethods
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
      content = get_replace_outer_image_url(content)
    end
    content
  end

  def build_markdown_file_entity
    return true if @markdown.blank?

    build_outer_image_file_entity(@markdown)
    if !self.file_entity.blank?
      old_content = File.open(self.file_entity.attach.path).read
      return true if old_content == @markdown
    end

    self.file_entity = FileEntity.create_by_text!(@markdown, :ext => '.md')
    self.kind = 'markdown'
    return true
  end

end