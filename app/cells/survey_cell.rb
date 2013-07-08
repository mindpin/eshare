class SurveyCell < Cell::Rails
  def form(opts = {})
    @survey = opts[:survey]
    @survey_result = opts[:survey_result]
    @user = opts[:user]
    @teacher = opts[:teacher]
    render
  end

  def result(opts = {})
    @survey = opts[:survey]
    @user = opts[:user]
    @teacher = opts[:teacher]
    @survey_result = @survey.get_result_for_teacher_of(@teacher, @user)
    render
  end
end