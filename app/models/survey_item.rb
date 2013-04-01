class SurveyItem < ActiveRecord::Base
  attr_accessible :content, :choice_options, :kind

  belongs_to :survey

  validates :content, :choice_options, :kind, :survey,
            :presence => true
end
