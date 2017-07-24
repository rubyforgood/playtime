class RemoveItemIdFromPledges < ActiveRecord::Migration[5.1]
  def change
    remove_column :pledges, :item_id, :integer
  end
end
