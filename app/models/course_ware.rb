class CourseWare < ActiveRecord::Base
  attr_accessible :title, :desc

  validates :title, :desc, :chapter, :creator,
            :presence => true
            
  belongs_to :chapter
  belongs_to :creator, :class_name => 'User'
  belongs_to :media_resource

  def kind
    kind = read_attribute("kind")
    kind.blank? ? kind : kind.to_sym 
  end

  def link_media_resource(media_resource)
    kind = media_resource.file_entity.content_kind
    self.kind = kind
    self.media_resource = media_resource
    self.save
  end

end