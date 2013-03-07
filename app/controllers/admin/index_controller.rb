class Admin::IndexController < ApplicationController
  layout 'admin'
  before_filter :login_required
  before_filter :is_admin?
  def is_admin?
    if !current_user.is_admin?
      redirect_to "/"
    end
  end

  def index
  end
end
