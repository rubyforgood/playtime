class Wishlist < ApplicationRecord
  has_many :site_managers
  has_many :users, through: :site_managers
  has_many :wishlist_items
  has_many :items, through: :wishlist_items
end
