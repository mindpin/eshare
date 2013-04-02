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


  resources :questions, :shallow => true do
    resources :answers
  end

  scope '/answers/:answer_id' do
    match "answer_votes/up" => "answer_votes#up"
    match "answer_votes/down" => "answer_votes#down"
    match "answer_votes/cancel" => "answer_votes#cancel"
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
