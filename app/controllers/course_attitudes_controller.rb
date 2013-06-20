class CourseAttitudesController < ApplicationController
  before_filter :authenticate_user!

  def create
    @course = Course.find params[:course_id]
    kind = params[:kind]
    content = params[:content]
    current_user.set_course_attitude(@course, kind, content)

    return render :json => {
      :status => 'ok', 
      :html => (render_cell :course, :user_attitudes_form, 
                                     :course => @course, 
                                     :user => current_user)
    }
  end
end