class ApplicationController < ActionController::Base
  protect_from_forgery
  include AuthenticatedSystem
  include ApplicationMethods

  def flash_error(arg)
    flash[:error] = arg.is_a?(String) ? arg : arg.errors.messages.values.first
  end
end
