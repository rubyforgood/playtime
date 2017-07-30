Rails.application.routes.draw do

  root to: 'wishlist_items#index'

  # Pledges
  get 'pledges/export_csv', to: 'pledges#export_csv'
  resources :pledges

  resources :wishlists do
    resources :wishlist_items, only: [:create]
  end
  resources :wishlist_items, only: [:index, :edit, :update, :destroy]

  get '/wishlists/:wishlist_id/items/search', to: 'items#search',
                                              as: 'search'
  get '/items/results', to: 'items#results', as: 'results'
  post '/wishlists/:wishlist_id/items/search_amazon', to: 'items#search_amazon',
                                                      as: 'search_amazon'

  # Users
  get 'users/export_csv', to: 'users#export_csv'
  resources :users, only: [:show, :index, :edit, :update, :destroy]
  get '/dashboard', to: 'dashboard#show' 

  # OAuth
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/signin' => 'sessions#new', :as => :signin
  get '/signout' => 'sessions#destroy', :as => :signout
  get '/auth/failure' => 'sessions#failure'

  # Items
  resources :items

end
