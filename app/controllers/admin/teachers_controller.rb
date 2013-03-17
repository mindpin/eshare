class Admin::TeachersController < ApplicationController
  layout 'admin'
  before_filter :authenticate_user!
  
  def import
  end

  def do_import
    file = params[:excel_file]
    User.import(file, :teacher)

    render :nothing => true
  end

end