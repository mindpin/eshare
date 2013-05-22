class Tag < MindpinSimpleTags::Tag
  attr_accessible :icon
  mount_uploader :icon, TagIconUploader
  include TagFollow::TagMethods

  def self.popular_tags(opts = {})
    count = opts[:count] || 20

    sql = %~
      SELECT tags.*, count(1) AS C
      FROM tags
      JOIN taggings ON taggings.tag_id = tags.id
      GROUP BY tags.id
      ORDER BY C DESC
      LIMIT #{count}
    ~

    Tag.find_by_sql sql
  end
end