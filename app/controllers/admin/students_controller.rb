class Admin::StudentsController < ApplicationController
  layout 'admin'
  before_filter :login_required
  before_filter :per_load
  def per_load
    @student = Student.find(params[:id]) if params[:id]
  end
  
  def index
    if params[:by_name]
      @students = sort_scope(Student).real_name_equals(params[:by_name]).paginated(params[:page])
      return
    end

    if params[:by_team_id]
      team = Team.find(params[:by_team_id])
      @students = sort_scope(Student).of_team(team).paginated(params[:page])
      return
    end

    @students = sort_scope(Student).paginated(params[:page])    
  end
  
  def new
    @student = Student.new
    @student.build_user
  end

  def create
    @student = Student.new(params[:student])
    if @student.save
      return redirect_to "/admin/students/#{@student.id}"
    end
    error = @student.errors.first
    flash[:error] = error[1]
    redirect_to "/admin/students/new"
  end
  
  # for ajax
  def destroy
    @student.remove
    render :text => 'ok'
  end
  
  def show
  end

  def edit
  end

  def update
    if @student.update_attributes params[:student]
      return redirect_to "/admin/students/#{@student.id}"
    end
    error = @student.errors.first
    flash[:error] = error[1]
    redirect_to "/admin/students/#{@student.id}/edit"
  end

  def import_from_csv_page
  end

  def import_from_csv
    Student.import_from_csv(params[:csv_file])
    redirect_to "/admin/students"
  rescue Exception=>ex
    flash[:error] = ex.message
    redirect_to "/admin/students/import_from_csv_page"
  end

  def password;end
  def password_submit
    if @student.update_attributes params[:student]
      return redirect_to "/admin/students/#{@student.id}"
    end
    error = @student.errors.first
    flash[:error] = error[1]
    redirect_to "/admin/students/#{@student.id}/password"
  end

  def upload_attachment
    file_entity = FileEntity.find(params[:file_entity_id])
    @student.save_attachment(params[:kind],file_entity)
    render :text=>"OK"
  end

end
