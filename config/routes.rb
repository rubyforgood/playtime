Rails.application.routes.draw do
  get 'wishlist_items/index'
  root to: "wishlists_items#index"
  resources :items
end
