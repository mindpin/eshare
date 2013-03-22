class Homework < ActiveRecord::Base
  attr_accessible :title, :content, :deadline,
                  :homework_requirements_attributes,
                  :homework_attaches_attributes

  belongs_to :chapter
  belongs_to :creator, :class_name => 'User'

  validates :title, :content, :deadline, :chapter, :creator,
            :presence => true

  has_many :homework_requirements
  has_many :homework_attaches
  has_many :homework_records
  has_many :homework_uploads

  accepts_nested_attributes_for :homework_requirements
  accepts_nested_attributes_for :homework_attaches
end