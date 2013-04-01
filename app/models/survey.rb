class Survey < ActiveRecord::Base
  attr_accessible :title, :content

  belongs_to :creator, :class_name => 'User'

  validates :title, :content, :creator, :presence => true

  has_many :survey_items
  has_many :survey_results
end
