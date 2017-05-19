Rails.application.routes.draw do
  root to: "wishlist_items#index"
  resources :items
end
