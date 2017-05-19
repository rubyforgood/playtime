Rails.application.routes.draw do
  get 'wishlist_items/index'
  root at: "wishlists_items#index"
  resources :items
end
