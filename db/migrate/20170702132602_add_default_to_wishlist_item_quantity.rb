class AddDefaultToWishlistItemQuantity < ActiveRecord::Migration[5.1]
  def change
    change_column_default :wishlist_items, :quantity, from: nil, to: 0
    change_column_null :wishlist_items, :quantity, false
  end
end
