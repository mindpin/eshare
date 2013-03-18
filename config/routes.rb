Eshare::Application.routes.draw do
  root :to => 'index#index'
  get '/dashboard' => 'index#dashboard'

  # devise
  devise_for :users, :path => 'account',
                     :controllers => {
                       :registrations => :account,
                       :sessions => :sessions
                     }

  devise_scope :user do
    get 'account/avatar' => 'account#avatar'
    put 'account/avatar' => 'account#avatar_update'
  end
  
  namespace :admin do
    root :to => 'index#index'

    resources :teachers do
      collection do
        get :import
        post :do_import
      end
      member do
        get :password
        put :password_submit
        get 'course/:course_id', :action => 'course_students'
      end
    end

    resources :students do
      collection do
        get :import
        post :do_import
      end
    end

    resources :users do
      member do
        get :student_attrs
        get :teacher_attrs
        put :user_attrs_update
        put :change_password
      end

      collection do
        get :import
      end
    end

    resources :attrs_configs do
      collection do
        get :teacher_attrs
        get :student_attrs
      end
    end 
  end

  # 资源网盘
  get '/disk' => 'disk#index'
  post '/upload' => 'files#upload'
end
