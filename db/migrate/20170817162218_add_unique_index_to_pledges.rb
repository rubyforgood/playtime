class AddUniqueIndexToPledges < ActiveRecord::Migration[5.1]
  def change
    add_index :pledges, %i[user_id wishlist_item_id], unique: true
  end
end
