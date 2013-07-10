class SurveysController < ApplicationController
  before_filter :authenticate_user!

  def index
    @surveys = Survey.page params[:page]
  end

  def show
    @teacher = User.find params[:teacher]
    @survey = Survey.find params[:id]
    @survey_result = SurveyResult.new
    @survey_result.teacher_user_id = @teacher.id
  end

  def submit
    data = params[:survey_result]
    survey_result_items_attributes = data[:survey_result_items].map {|k, v| v}

    @survey = Survey.find params[:id]
    @teacher = User.find params[:teacher_id]
    @survey_result = _get_survey_result(@survey)
    @survey_result.teacher_user_id = @teacher.id
    @survey_result.survey_result_items_attributes = survey_result_items_attributes

    # render :json => survey_result_items_attributes

    if @survey_result.valid?
      SurveyResultItem.where(:survey_result_id => @survey_result.id).destroy_all
      @survey_result.save
      redirect_to "/surveys/#{@survey.id}?teacher=#{@teacher.id}"
      return
    end

    params[:refill] = true
    render :action => :show
  end

  def _get_survey_result(survey)
    if survey.has_completed_for_teacher_by?(@teacher, current_user)
      return survey.get_result_for_teacher_of(@teacher, current_user)
    end

    result = @survey_result = @survey.survey_results.build
    result.user = current_user
    return result
  end

  def select_teacher
    @survey = Survey.find params[:id]
    @teachers = User.with_role(:teacher).page params[:page]
  end
end