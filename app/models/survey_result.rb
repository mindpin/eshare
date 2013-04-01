class SurveyResult < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User'
  belongs_to :survey

  validates :creator, :survey, :presence => true

  has_many :survey_result_items
end
