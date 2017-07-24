class ChangeWishlistItemsPriorityToInteger < ActiveRecord::Migration[5.1]
  def change
    remove_column :wishlist_items, :priority, :string
    add_column :wishlist_items, :priority, :integer, default: 0,
                                                     index: true,
                                                     null: false
  end
end
