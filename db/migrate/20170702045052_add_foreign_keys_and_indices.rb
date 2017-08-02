class AddForeignKeysAndIndices < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :pledges, :users
    add_index :pledges, :user_id

    add_foreign_key :site_managers, :users
    add_foreign_key :site_managers, :wishlists
    add_index :site_managers, :user_id
    add_index :site_managers, :wishlist_id

    add_foreign_key :wishlist_items, :items
    add_foreign_key :wishlist_items, :wishlists
    add_index :wishlist_items, :item_id
    add_index :wishlist_items, :wishlist_id
  end
end
