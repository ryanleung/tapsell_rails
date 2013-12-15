Tapsell::Application.routes.draw do

  ##################################
  # Web app routes
  ##################################

  resources :users
  match '/sign-up', to: 'users#new', via: 'get'
  
  ##################################
  # Static page routes
  ##################################

  root 'static_pages#landing'
  match '/about', to: 'static_pages#about', via: 'get'
  match '/team', to: 'static_pages#team', via: 'get'
  match '/jobs', to: 'static_pages#jobs', via: 'get'
  match '/blog', to: 'static_pages#blog', via: 'get'
  match '/contact', to: 'static_pages#contact', via: 'get'
  match '/faq', to: 'static_pages#faq', via: 'get'
  match '/buyer_faq', to: 'static_pages#buyer_faq', via: 'get'
  match '/terms', to: 'static_pages#terms', via: 'get'
  match '/privacy', to: 'static_pages#privacy', via: 'get'
  match '/buyer_guarantee', to: 'static_pages#buyer_guarantee', via: 'get'

  ##################################
  # API methods
  ##################################

  namespace :api do
    post 'users' => 'users#create'
    get 'users/:user_id' => 'users#show'
    post 'users/profile' => 'users#update'
    post 'sessions' => 'sessions#create'
    delete 'sessions' => 'sessions#destroy'
    get 'listings' => 'listings#index'
    post 'listings' => 'listings#create'
    delete 'listings' => 'listings#destroy'
  end


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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