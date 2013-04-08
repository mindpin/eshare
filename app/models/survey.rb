class Survey < ActiveRecord::Base
  attr_accessible :title, :content

  belongs_to :creator, :class_name => 'User'

  validates :title, :creator, :presence => true

  has_many :survey_items
  has_many :survey_results

  def is_answered?(current_user)
    self.survey_results.where(:creator_id => current_user.id).present?
  end

  module UserMethods
    def self.included(base)
      base.has_many :surveys, :foreign_key => :creator_id
    end
  end
end
