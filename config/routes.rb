  Rails.application.routes.draw do\

  get '/students/login', :to => 'students#new', :as => :login
  get '/auth/:provider/callback' => 'students#create', :as => :omniauth_callback
  get '/auth/index' =>'students#index'
  get '/students/logout', :to => 'students#destroy'
  get '/requests' => 'requests#index'
  get '/students/cohort' => "students#cohort", :as => :get_cohort
  get '/students/dashboard' => "students#index"
  get '/students/require_approval' => "pages#require_approval"
  
  resources :teachers, only:[:update] do
    collection do
      get 'dashboard'
      get 'students'
      get 'approve_student'
      get 'unapprove_student'
      get 'delete_student'
      get 'edit_student'
    end
  end
  
  resources :categories, only:[:index, :new, :create, :edit, :update, :destroy]
  resources :cohorts, only:[:index, :new, :create, :edit, :update, :destroy]
  resources :students
  resources :requests do
    collection do 
      get 'solved'
    end
  end


  devise_for :teachers

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  
  root 'pages#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
