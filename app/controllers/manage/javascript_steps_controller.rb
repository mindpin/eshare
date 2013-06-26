class Manage::JavascriptStepsController < ApplicationController
  def form_html
    @step = JavascriptStep.find params[:id]
    render :text => (
      render_cell :course_ware, :javascript_steps_form, :course_ware => @step.course_ware,
                                                      :current_step => @step
    )
  end

  def update
    @step = JavascriptStep.find params[:id]
    @step.update_attributes params[:javascript_step]
    render :text => 'ok'
  end

  def create
    @course_ware = CourseWare.find params[:course_ware_id]
    @step = @course_ware.javascript_steps.create

    render :text => (
      render_cell :course_ware, :javascript_steps_form, :course_ware => @step.course_ware,
                                                      :current_step => @step
    )
  end

  def destroy
    @step = JavascriptStep.find params[:id]
    @step.destroy
    render :text => (
      render_cell :course_ware, :javascript_steps_form, :course_ware => @step.course_ware,
                                                      :current_step => nil
    )
  end
end