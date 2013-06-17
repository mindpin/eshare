class SurveysController < ApplicationController
  before_filter :authenticate_user!

  def index
    @surveys = Survey.page params[:page]
  end

  def show
    @survey = Survey.find params[:id]
    @survey_result = SurveyResult.new
  end

  def submit
    data = params[:survey_result]
    survey_result_items_attributes = data[:survey_result_items].map {|k, v| v}

    @survey = Survey.find params[:id]
    @survey_result = _get_survey_result(@survey)
    @survey_result.survey_result_items_attributes = survey_result_items_attributes

    # render :json => survey_result_items_attributes

    if @survey_result.valid?
      SurveyResultItem.where(:survey_result_id => @survey_result.id).destroy_all
      @survey_result.save
      redirect_to :action => :show
      return
    end

    params[:refill] = true
    render :action => :show
  end

  def _get_survey_result(survey)
    if survey.has_completed_by?(current_user)
      return survey.get_result_of(current_user)
    end

    result = @survey_result = @survey.survey_results.build
    result.user = current_user
    return result
  end
end