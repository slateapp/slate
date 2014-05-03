  Rails.application.routes.draw do\

  root 'pages#index'

  get '/students/login', :to => 'students#new', :as => :login
  get '/auth/:provider/callback' => 'students#create', :as => :omniauth_callback
  get '/auth/index' =>'students#index'
  get '/students/logout', :to => 'students#destroy'
  get '/requests' => 'requests#index'
  get '/students/cohort' => "students#cohort", :as => :get_cohort
  get '/students/dashboard' => "students#index"
  get '/students/require_approval' => "pages#require_approval"
  
  devise_for :teachers
  resources :teachers, only:[:update] do
    collection do
      get 'dashboard'
      get 'students'
      get 'edit_student'
    end
  end

  resources :categories,  only:[:index, :new, :create, :edit, :update, :destroy]

  resources :cohorts,     only:[:index, :new, :create, :edit, :update, :destroy]

  resources :students
  resources :requests do
    collection do 
      get 'solved'
    end
  end

end
