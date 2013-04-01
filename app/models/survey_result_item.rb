class SurveyResultItem < ActiveRecord::Base
  attr_accessible :answer

  belongs_to :survey_result

  validates :survey_result, :answer_choice_mask, :answer_fill, :answer_text,
            :presence => true
end
