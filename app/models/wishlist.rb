class Wishlist < ApplicationRecord
  has_many :site_managers
  has_many :owners, through: :site_managers, class_name: User
  has_many :wishlist_items
  has_many :items, through: :wishlist_items
end
