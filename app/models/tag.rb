class Tag < ActiveRecord::Base
  attr_accessible :name

  validates :name, :presence => true

  has_many :taggings

  scope :by_name, lambda { |tag_name| {:conditions => "name = '#{tag_name}'"} }

  def self.get_by_str(str)
    tag_names = _split_str_to_array(str)
    tag_names.map do |name|
      Tag.find_or_create_by_name(name)
    end
  end

  private

  def self._split_str_to_array(str)
    str.split(/\s|,|，/).compact
  end
end