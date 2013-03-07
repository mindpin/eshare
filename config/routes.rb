Eshare::Application.routes.draw do
  root :to=>"index#index"
  get '/dashboard' => 'index#dashboard'
  namespace :auth do
  # ---------------- 首页和欢迎页面 ---------
  root :to => 'sessions#new'
  # 登入登出
  get  '/login'  => 'sessions#new'
  post '/login'  => 'sessions#create'
  get  '/logout' => 'sessions#destroy'


  # 用户设置
  # 基本信息
  get  "/setting"                     => "setting#base"
  put  "/setting"                     => "setting#base_submit"

  # 设置密码
  get '/setting/password'             => "setting#password"
  put '/setting/password'             => "setting#password_submit"

  # 头像设置
  get  "/setting/avatar"              => 'setting#avatar'
  get  '/setting/temp_avatar'         => 'setting#temp_avatar'
  post "/setting/avatar_submit_raw"   => 'setting#avatar_submit_raw'
  post "/setting/avatar_submit_crop"  => 'setting#avatar_submit_crop'
  end
  
  namespace :admin do
    root :to=>"index#index"
  end
end
