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

<<<<<<< HEAD
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
=======
    resources :users do
>>>>>>> 0c63cbcda24394bd4581529aa0e907d1e67b2ffa
      member do
        get :student_attrs
        get :teacher_attrs
        put :user_attrs_update
      end
    end
    
  end
end
