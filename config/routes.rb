Eshare::Application.routes.draw do
  root :to=>"index#index"
  get '/dashboard' => 'index#dashboard'

  # devise
  devise_for :users, :path => 'account',
                     :controllers => {
                       :registrations => :account,
                       :sessions => :sessions
                     }

  devise_scope :user do
    get  'account/avatar' => 'account#avatar'
    put 'account/avatar' => 'account#avatar_update'
  end
  
  namespace :admin do
    root :to=>"index#index"

    resources :users do
      member do
        get :student_attrs
        get :teacher_attrs
        put :user_attrs_update
      end
    end
    
  end
end
