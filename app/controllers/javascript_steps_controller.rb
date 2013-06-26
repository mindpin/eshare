class JavascriptStepsController < ApplicationController
  before_filter :authenticate_user!

  layout Proc.new { |controller|
    case controller.action_name
    when 'show', 'preview'
      return 'coding'
    else
      return 'application'
    end
  }

  def record_input
    input = params[:input]
    passed = params[:passed]

    step = JavascriptStep.find(params[:id])
    step.record_input(current_user, input, passed)

    render :text => 'ok'
  end

  def preview
    @step = JavascriptStep.find params[:id]
    @course_ware = @step.course_ware
    render :template => '/course_wares/javascript_coding'
  end

  def show
    @step = JavascriptStep.find params[:id]
    @course_ware = @step.course_ware
    render :template => '/course_wares/javascript_coding'
  end
end
