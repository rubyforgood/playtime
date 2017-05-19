Rails.application.routes.draw do
  root at: "wishlists_items#index"
  resources :items

  # OAuth
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/signin' => 'sessions#new', :as => :signin
  get '/signout' => 'sessions#destroy', :as => :signout
  get '/auth/failure' => 'sessions#failure'
end
