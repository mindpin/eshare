class Tag < MindpinSimpleTags::Tag
  attr_accessible :avatar
  mount_uploader :avatar, AvatarUploader
  include TagFollow::TagMethods
end