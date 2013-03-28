class Tag < ActiveRecord::Base
  attr_accessible :name

  validates :name, :presence => true, 
                   :uniqueness => {:case_sensitive => false}

  has_many :taggings

  scope :by_name, lambda { |tag_name| {:conditions => "name = '#{tag_name}'"} }
end