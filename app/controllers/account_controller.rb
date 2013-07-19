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
        render :json => {:sign_in => 'ok', :location => after_sign_up_path_for(resource)}
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        # respond_with resource, :location => after_inactive_sign_up_path_for(resource)
        render :json => {:sign_in => 'ok', :location => after_inactive_sign_up_path_for(resource)}
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

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    re = params[:by] == 'pwd' ? resource.update_with_password(resource_params) : resource.update_attributes(resource_params)

    if re
      if is_navigational_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, :bypass => true
      respond_with resource, :location => after_update_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  # def complete
  #   # 补全第三方账号直接登录的用户信息
  #   self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
  #   prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

  #   if resource.update_with_password(resource_params)
      
  #   end

  # end

  def avatar
  end

  def avatar_update

    origin_width  = params[:origin_width].to_f
    origin_height = params[:origin_height].to_f
    page_width    = params[:page_width].to_i
    page_height   = params[:page_height].to_i
    cx = params[:cx].to_i
    cy = params[:cy].to_i
    cw = params[:cw].to_i
    ch = params[:ch].to_i

    ratiox = origin_width / page_width
    ratioy = origin_height / page_height

    s = [(cw * ratiox).round, (ch * ratioy).round].min

    user = User.find(current_user.id)
    user.avatar_cw = s
    user.avatar_ch = s
    user.avatar_cx = (cx * ratiox).round
    user.avatar_cy = (cy * ratioy).round

    user.avatar = FileEntity.find(params[:file_entity_id]).attach
    user.save

    flash[:success] = "你的头像成功更新了"
    redirect_to :action => :avatar
  end

  def userpage
  end

  def userpage_update
    user = User.find(current_user.id)
    user.userpage_head = params[:user][:userpage_head]
    user.save
    redirect_to :action => :userpage
  end

  protected

    def after_update_path_for(resource)
      '/account/edit'
    end
end