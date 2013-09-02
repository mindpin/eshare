class Mist < ActiveRecord::Base
  MARKDOWN  = "markdown"
  JAVA      = 'java'
  JAVASCRPT = 'javascript'
  RUBY      = 'ruby'
  TEXT      = 'text'

  attr_accessible :desc, :kind, :file_entity, :content

  belongs_to :file_entity
  
  validates :kind, :presence => true, 
                   :inclusion  => [MARKDOWN, JAVA, JAVASCRPT, RUBY, TEXT]

  before_save :build_content_file_entity

  def content=(content)
    @content = content
  end

  def build_content_file_entity
    return true if @content.blank?

    if !self.file_entity.blank?
      old_content = File.open(self.file_entity.attach.path).read
      return true if old_content == @content
    end

    file = Tempfile.new(['file_name', _file_by_kind])
    file.write(@content)
    file.rewind
    self.file_entity = FileEntity.create!(:attach => file)
    file.unlink

    return true
  end

  private
    def _file_by_kind
      suffix = '.txt'

      case self.kind
      when MARKDOWN
        suffix = '.md'
      when JAVA
        suffix = '.java'
      when JAVASCRPT
        suffix = '.js'
      when RUBY
        suffix = '.rb'
      when TEXT
        suffix = '.txt'
      end
      return suffix
    end
end