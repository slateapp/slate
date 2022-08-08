# frozen_string_literal: true

Rails.application.routes.draw do
  root 'pages#index'

  get '/students/login', to: 'students#new', as: :login
  get '/auth/:provider/callback' => 'students#create', :as => :omniauth_callback
  get '/auth/index' => 'students#index'
  get '/students/logout', to: 'students#destroy'
  get '/requests' => 'requests#index'
  get '/students/cohort' => 'students#cohort', :as => :get_cohort
  get '/students/dashboard' => 'students#index'
  get '/students/require_approval' => 'pages#require_approval'
  get '/current_user' => 'pages#current_user'

  devise_for :teachers
  resources :teachers, only: [:update] do
    collection do
      get 'dashboard'
      get 'students'
      get 'edit_student'
      get 'statistics'
    end
  end

  resources :categories, only: %i[index new create edit update destroy]
  resources :twilio_infos
  resources :cohorts, only: %i[index new create edit update destroy] do
    collection do
      patch 'selected_cohorts'
      get 'current_cohorts'
    end
  end

  resources :students do
    collection do
      patch 'batch_change'
    end
  end
  resources :requests do
    collection do
      get 'solved'
      get 'display'
    end
  end
end
