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
  post "/setting/avatar_submit"   => 'setting#avatar_submit'
  end
  
  namespace :admin do
    root :to=>"index#index"

    resources :teachers do
      collection do
        get :import_from_csv_page
        post :import_from_csv
      end
      member do
        get :password
        put :password_submit
        get 'course/:course_id', :action => 'course_students'
      end
    end

    resources :students do
      collection do
        get :import_from_csv_page
        post :import_from_csv
      end
      member do
        get :password
        put :password_submit
        put :upload_attachment
      end
    end
    
  end
end
