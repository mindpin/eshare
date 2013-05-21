class Tag < MindpinSimpleTags::Tag
  attr_accessible :icon
  mount_uploader :icon, TagIconUploader
  include TagFollow::TagMethods
end