class SurveyCell < Cell::Rails
  def form(opts = {})
    @survey = opts[:survey]
    @survey_result = opts[:survey_result]
    @user = opts[:user]
    render
  end

  def result(opts = {})
    @survey = opts[:survey]
    @user = opts[:user]
    @survey_result = @survey.get_result_of(@user)
    render
  end
end