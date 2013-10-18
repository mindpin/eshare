# -*- coding: utf-8 -*-
Eshare::Application.routes.draw do
  default_url_options :host => "www.mindpin.com" # devise 发邮件需要用到
  # 参考
  # https://github.com/plataformatec/devise/wiki/How-To:-Create-custom-layouts
  # 来设置 devise 的布局

  root :to => 'index#index'
  get '/dashboard' => 'index#dashboard'
  get '/plan' => 'index#plan'

  # install
  get '/install' => 'install#index'
  get '/install/:step' => 'install#step'
  post '/install/submit/:step' => 'install#step_submit'

  # /auth/weibo/callback
  get '/auth/:provider/callback' => 'oauth#callback'
  post '/auth/:provider/unbind' => 'oauth#unbind'

  # devise
  devise_for :users, :path => 'account',
                     :controllers => {
                       :registrations => :account,
                       :sessions => :sessions
                     }

  devise_scope :user do
    get 'account/avatar' => 'account#avatar'
    put 'account/avatar' => 'account#avatar_update'
    get 'account/userpage' => 'account#userpage'
    put 'account/userpage' => 'account#userpage_update'
    get '/account/sync'  => 'oauth#sync'
  end

  resources :announcements

end

# 搜索
Eshare::Application.routes.draw do
  get 'search/:query' => 'search#search'
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

    member do
      get :followings
      get :followers
    end
  end
end

# 个人页
Eshare::Application.routes.draw do
  resources :users, :shallow => true do
    collection do
      get :me
      get :complete_search
    end

    member do
      get :courses
      get :questions
      get :answers
      get :course_applies
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
        get :download_import_sample
        get :import
        post :do_import
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

    resources :user_opinions
    resources :site_changes
  end
end

# 资源网盘
Eshare::Application.routes.draw do
  post '/upload' => 'files#upload'
  post '/upload_clipboard' => 'files#upload_clipboard'
  
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
    resources :applies, :shallow => true do
      collection do
        get :status_request
        get :status_accept
        get :status_reject
      end
    end
    
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
          collection do
            get :import_javascript_course_ware
            post :do_import_javascript_course_ware
          end

          member do
            put :move_up
            put :move_down
            put :do_convert
            get :export_json
          end

          resources :javascript_steps, :shallow => true do
            member do
              get :form_html
            end
          end
        end
      end

      resources :applies, :shallow => true, :controller => :course_applies do
        member do
          put :accept
          put :reject
        end

        collection do
          get :status_request
          get :status_accept
          get :status_reject
        end
      end
    end

    namespace :aj do
      resources :courses, :shallow => true do
        resources :chapters, :shallow => true
      end
    end
  end
end

# 一般用户访问课程
Eshare::Application.routes.draw do
  resources :courses, :shallow => true do
    member do
      post :checkin
      post :student_select
      get :users_rank
      get :questions
      get :notes
    end

    collection do
      get :sch_select
    end

    resources :chapters, :shallow => true do
      resources :course_wares, :shallow => true do
        resources :questions, :shallow => true

        resources :javascript_steps, :shallow => true do
          member do
            post :record_input
            get :preview
          end
        end

        member do
          put :update_read_count
          post :add_video_mark
        end
      end
      resources :questions, :shallow => true
    end

    resources :course_attitudes, :shallow => true
  end
end

# 图表
Eshare::Application.routes.draw do
  namespace :charts do
    
    resources :courses, :shallow => true do
      collection do
        get :all_courses_read_pie
        get :all_courses_punch_card
        get :all_courses_select_apply_pie
      end

      member do
        get :read_pie
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

# 用户反馈 INTERNET
Eshare::Application.routes.draw do
  namespace :help do
    resources :user_opinions, :shallow => true
    resources :site_changes, :shallow => true
  end
end

# mist
Eshare::Application.routes.draw do
  resources :mists, :shallow => true
end

# KnowledgeQuestion 相关
Eshare::Application.routes.draw do
  namespace :admin do
    resources :knowledge_questions, :shallow => true
  end

  resources :knowledge_tests, :shallow => true
end

# 一般用户进行知识水平测试
Eshare::Application.routes.draw do
  namespace :knowledge_test do
    resources :questions, :shallow => true do
      member do
        post :submit_answer
      end
    end

    resources :notes, :shallow => true do
    end
  end
end
