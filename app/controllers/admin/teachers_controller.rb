class Admin::TeachersController < ApplicationController
  layout 'admin'
  before_filter :authenticate_user!
  before_filter :per_load

  def per_load
    @teacher = Teacher.find(params[:id]) if params[:id]
  end
  
  def index
    @teachers = sort_scope(Teacher).paginated(params[:page])
  end

  def new
    @teacher = Teacher.new
    @teacher.build_user
  end
  
  def create
    @teacher = Teacher.new(params[:teacher])
    if @teacher.save
      return redirect_to "/admin/teachers/#{@teacher.id}"
    end
    flash_error @teacher
    redirect_to "/admin/teachers/new"
  end
  
  # for ajax
  def destroy
    @teacher.remove
    render :text => 'ok'
  end

  def show
    #@courses = @teacher.user.get_teacher_courses :semester => get_semester
  end

  def course_students
    @course = Course.find params[:course_id]
    @students = @course.get_current_students_of(@teacher.user)
  end

  def edit
  end

  def update
    if @teacher.update_attributes params[:teacher]
      return redirect_to "/admin/teachers/#{@teacher.id}"
    end
    flash_error @teacher
    redirect_to "/admin/teachers/#{@teacher.id}/edit"
  end

  def import_from_csv_page
  end

  def import_from_csv
    Teacher.import_from_csv(params[:csv_file])
    redirect_to "/admin/teachers"
  rescue Exception=>ex
    flash_error ex.message
    redirect_to "/admin/teachers/import_from_csv_page"
  end

  def password;end
  def password_submit
    if @teacher.update_attributes params[:teacher]
      return redirect_to "/admin/teachers/#{@teacher.id}"
    end
    flash_error @teacher
    redirect_to "/admin/teachers/#{@teacher.id}/password"
  end

end
