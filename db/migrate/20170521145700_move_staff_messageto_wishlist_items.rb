class MoveStaffMessagetoWishlistItems < ActiveRecord::Migration[5.1]
  def change
    remove_column :items, :staff_message, :text
    add_column :wishlist_items, :staff_message, :text
  end
end
