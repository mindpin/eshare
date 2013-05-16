# -*- coding: utf-8 -*-
Eshare::Application.routes.draw do
  root :to => 'index#index'
  get '/dashboard' => 'index#dashboard'
  get '/plan' => 'index#plan'

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

  resources :announcements

  resources :surveys, :shallow => true do
    resources :survey_items
    resources :survey_results
  end
end

# 标签
Eshare::Application.routes.draw do
  resources :tags do
    collection do
      put :set_tags
    end

  end

  get '/tags/courses/:tagname' => 'tags#courses'
end

# 短消息
Eshare::Application.routes.draw do
  resources :short_messages, :shallow => true do
    collection do
      get :chatlog
    end
  end
end

# 用户关系
Eshare::Application.routes.draw do
  resources :friends, :shallow => true do
    collection do
      post :follow
      post :unfollow
    end
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
    member do
      post :follow
      post :unfollow
    end

    resources :answers do
      member do
        put :vote_up
        put :vote_down
        put :vote_cancel
      end
    end
  end
end

# 课程
Eshare::Application.routes.draw do
  namespace :manage do
    resources :courses, :shallow => true do
      collection do
        get :download_import_sample
        get :import
        post :do_import

        get :import_youku_list
        post :import_youku_list_2
        post :do_import_youku_list

        get :import_tudou_list
        post :import_tudou_list_2
        post :do_import_tudou_list
      end

      resources :chapters, :shallow => true do
        member do
          put :move_up
          put :move_down
        end

        resources :course_wares, :shallow => true do
          member do
            put :move_up
            put :move_down
            put :do_convert
          end
        end
      end
    end

    namespace :aj do
      resources :courses, :shallow => true do
        resources :chapters, :shallow => true
      end
    end
  end

  resources :courses, :shallow => true do
    member do
      post :checkin
      get :users_rank
    end

    resources :chapters, :shallow => true do
      resources :course_wares, :shallow => true do
        member do
          put :update_read_count
          post :add_video_mark
        end
      end
      resources :questions, :shallow => true
    end
  end
end

# 图表
Eshare::Application.routes.draw do
  namespace :charts do
    
    resources :courses, :shallow => true do
      collection do
        get :all_courses_read_pie
        get :all_courses_punch_card
      end

      resources :chapters, :shallow => true do
        member do
          get :read_pie
        end

        resources :course_wares, :shallow => true do
          member do
            get :read_count_last_week
          end
        end
      end
    end
  end
end
