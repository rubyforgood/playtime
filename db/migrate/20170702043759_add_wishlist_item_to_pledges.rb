class AddWishlistItemToPledges < ActiveRecord::Migration[5.1]
  def change
    add_reference :pledges, :wishlist_item, foreign_key: true
  end
end
