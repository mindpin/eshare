class JavascriptStepsController < ApplicationController
  before_filter :authenticate_user!

  def record_input
    input = params[:input]
    passed = params[:passed]

    step = JavascriptStep.find(params[:id])
    step.record_input(current_user, input, passed)

    render :text => 'ok'
  end
end
