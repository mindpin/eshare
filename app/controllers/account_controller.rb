class AccountController < Devise::RegistrationsController
  layout Proc.new { |controller|
    if controller.request.headers['X-PJAX']
      return false
    end

    case controller.action_name
    when 'new', 'create'
      return 'auth'
    when 'edit'
      return 'account'
    else
      return 'account'
    end
  }

  def new
    super
  end

  def create
    if !request.xhr?
      return super
    end

    build_resource

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        # respond_with resource, :location => after_sign_up_path_for(resource)
        render :json => {:sign_in => 'ok'}
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        # respond_with resource, :location => after_inactive_sign_up_path_for(resource)
        render :json => {:sign_in => 'ok'}
      end
    else
      clean_up_passwords resource
      # respond_with resource
      render :json => resource.errors.map{|k, v| v}.uniq, :status => 403
    end
  end

  def edit
    super
  end

  def avatar
  end

  def avatar_update
    user = User.find(current_user.id)
    user.avatar = params[:user][:avatar]
    user.save
    redirect_to :action => :avatar
  end

  protected

    def after_update_path_for(resource)
      '/account/edit'
    end
end