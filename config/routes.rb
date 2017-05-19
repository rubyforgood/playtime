Rails.application.routes.draw do
  get 'wishlist_items/index'

  resources :items
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
