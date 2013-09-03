class Mist < ActiveRecord::Base
  KIND_DATA = {
    "markdown" => '.md',
    "java"     => ".java",
    "javascript" => '.js',
    "ruby"     => '.rb',
    "text"     => '.text'
  }

  attr_accessible :desc, :kind, :file_entity, :content

  belongs_to :file_entity
  
  validates :kind, :presence => true, :inclusion  => KIND_DATA.keys

  before_save :build_content_file_entity

  def content=(content)
    @content = content
  end

  def content
    if new_record?
      content = @content || ""
    else
      content = @content || (File.open(self.file_entity.attach.path).read)
    end
    content
  end

  def build_content_file_entity
    return true if @content.blank?

    if !self.file_entity.blank?
      old_content = File.open(self.file_entity.attach.path).read
      return true if old_content == @content
    end

    self.file_entity = FileEntity.create_by_text!(
      @content, :ext => KIND_DATA[self.kind]
    )

    return true
  end
end