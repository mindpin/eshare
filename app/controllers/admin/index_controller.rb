class Admin::IndexController < ApplicationController
  layout 'admin'
  before_filter :authenticate_user!
  before_filter :is_admin?
  def is_admin?
    if !current_user.is_admin?
      redirect_to "/"
    end
  end

  def index
    redirect_to "/admin/users"
  end
end
