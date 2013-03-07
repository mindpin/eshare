class Auth::SessionsController < ApplicationController
  include SessionsMethods
  include SessionsControllerMethods

  layout 'auth'
end
