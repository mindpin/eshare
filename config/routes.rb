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

  # 课程
  resources :courses, :shallow => true do
    collection do
      get :manage
      get :import
      post :do_import
    end
      
    resources :chapters, :shallow => true do
      resources :course_wares
      resources :homeworks do
        member do
          get :student
        end
      end
    end
  end
  resources :homework_requirements do
    member do
      post :upload
    end
  end

  resources :announcements

  resources :tags do
    collection do
      put :set_tags
    end
  end

  resources :surveys, :shallow => true do
    resources :survey_items
    resources :survey_results
  end
end

# 管理员
Eshare::Application.routes.draw do
  namespace :admin do
    root :to => 'index#index'

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

    resources :categories do
      collection do
        post :do_import
      end
    end
  end
end

# 资源网盘
Eshare::Application.routes.draw do
  post '/upload' => 'files#upload'
  post '/disk/create_folder' => 'disk#create_folder'

  get    '/disk'        => 'disk#index'
  post   '/disk/create' => 'disk#create'
  delete '/disk'        => 'disk#destroy'
  get    '/disk/file'   => 'disk#show'
end

# 问答和问答投票
Eshare::Application.routes.draw do
  resources :questions, :shallow => true do
    resources :answers do
      member do
        put :vote_up
        put :vote_down
        put :vote_cancel
      end
    end
  end
end
