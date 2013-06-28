module SimpleSurvey
  class SurveyResult
    validates :teacher_user_id, :presence => true
    validates :survey_id, :uniqueness => {:scope => [:user_id, :teacher_user_id]}
  end
end