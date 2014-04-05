Tapsell::Application.routes.draw do

  get "dashboard/show"
  ##################################
  # Web app routes
  ##################################

  # Generic resources
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :password_resets
  resources :listings

  # Checkout process
  get "purchases/listings/:id" => "purchases#new", as: 'new_purchase'
  post "purchases/listings/:id/" => "purchases#create_authorization", as: 'purchase'
  get "purchases/listings/:id/confirmation" => "purchases#purchase_confirmation", as: 'purchase_confirmation'

  # View messags
  get "users/:id/message" => "messages#index", as: 'messages'
  
  # Listings
  get "newest_listings" => "listings#newest_listings", as: 'newest_listings'
  get "oldest_listings" => "listings#oldest_listings", as: 'oldest_listings'
  get "low_price_listings" => "listings#low_price_listings", as: 'low_price_listings'
  get "high_price_listings" => "listings#high_price_listings", as: 'high_price_listings'
  get "all_listings" => "listings#all_listings", as: 'all_listings'
  get "book_listings" => "listings#book_listings", as: 'book_listings'
  get "apparel_listings" => "listings#apparel_listings", as: 'apparel_listings'
  get "electronic_listings" => "listings#electronic_listings", as: 'electronic_listings'
  get "home_listings" => "listings#home_listings", as: 'home_listings'
  get "ticket_listings" => "listings#ticket_listings", as: 'ticket_listings'
  get "other_listings" => "listings#other_listings", as: 'other_listings'

  # Payment settings
  get "users/:id/payment_settings" => "payment_settings#index", as: 'payment_settings'
  post "users/:id/payment_settings" => "credit_cards#create_card", as: 'create_card'
  post "users/:id/payment_settings" => "checks#create", as: 'create_check'

  # View public profiles
  get "users/:id/view" => "users#show_public", as: 'public_profile'

  # View my listings
  get "users/:id/listings" => "listings#show_my_listings", as: 'my_listings'

  # View user dashboard
  get "users/:id/dashboard" => "dashboard#show", as: 'dashboard'

  # Authentication
  match '/sign-up', to: 'users#new', via: 'get'
  match 'sign-in', to: 'sessions#new', via: 'get', as: 'sign_in'
  match '/sign-out', to: 'sessions#destroy', via: 'delete'

  ##################################
  # Static page routes
  ##################################

  root :to => 'users#root_page_router'
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
    get 'users/profile' => 'users#index'
    post 'users/profile/edit' => 'users#update'
    get 'users/:user_id' => 'users#show'
    post 'sessions' => 'sessions#create'
    delete 'sessions' => 'sessions#destroy'
    get 'listings' => 'listings#index'
    post 'listings' => 'listings#create'
    delete 'listings' => 'listings#destroy'
    get 'messages' => 'messages#index'
    post 'messages' => 'messsages#create'
    get 'messages/:msg_chain_id/chain' => 'messages#messages_in_chain',
      :msg_chain_id => /[\w.-]+/
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
