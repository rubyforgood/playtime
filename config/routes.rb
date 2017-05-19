Rails.application.routes.draw do
  root at: "wishlists_items#index"
  resources :items
end
