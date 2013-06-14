class Survey < SimpleSurvey::Survey
  def has_completed_by?(user)
    self.survey_results.where(:user_id => user.id).present?
  end

  def get_result_of(user)
    self.survey_results.where(:user_id => user.id).first
  end
end

