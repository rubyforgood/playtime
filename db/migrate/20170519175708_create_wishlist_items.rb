

class CreateWishlistItems < ActiveRecord::Migration[5.1]
  def change
    create_table :wishlist_items do |t|
      t.integer :quantity
      t.string :priority
      t.integer :wishlist_id
      t.integer :item_id

      t.timestamps
    end
  end
end
