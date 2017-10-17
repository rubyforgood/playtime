Rails.application.routes.draw do
  # Pledges
  resources :pledges, except: [:new] do
    patch :claim
  end

  # Wishlists & Items
  resources :wishlists, except: [:index] do
    resources :wishlist_items, shallow: true,
                               only: [:create, :edit, :update, :destroy]
    resource :amazon_search,   controller: :amazon_search,
                               only: [:new, :show]
  end

  # Users
  resources :users

  # OAuth
  controller :sessions do
    get '/auth/:provider/callback', action: :create
    post '/auth/:provider/callback', action: :create
    get '/auth/failure', action: :failure

    get '/signin', action: :new, as: :signin
    get '/signout', action: :destroy, as: :signout
  end


  root to: 'wishlist_items#index'
end
