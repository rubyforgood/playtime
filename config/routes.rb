Rails.application.routes.draw do
  get 'wishlist_items/index'
  root to: "wishlist_items#index"
  resources :items
end
