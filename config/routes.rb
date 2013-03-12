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
