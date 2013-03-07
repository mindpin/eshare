class ApplicationController < ActionController::Base
  protect_from_forgery
  include AuthenticatedSystem
  include ApplicationMethods

  def flash_error(arg)
    flash[:error] = arg.is_a?(String) ? arg : arg.errors.messages.values.first
  end

  def sort_dir
    ['asc', 'desc'].include?(params[:dir].to_s) ? params[:dir] : nil
  end

  def sort_scope_sym
    params[:sort] ? "by_#{params[:sort]}" : nil
  end

  def sort_params_to_scope
    [sort_scope_sym, sort_dir].compact
  end

  def sort_scope(resource)
    return resource if sort_params_to_scope.blank?
    resource.send(*sort_params_to_scope)
  rescue NoMethodError
    redirect_to :action => :index
    resource
  end
end
