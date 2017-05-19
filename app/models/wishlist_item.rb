class WishlistItem < ApplicationRecord
  belongs_to :wishlist
  has_one :item
end
