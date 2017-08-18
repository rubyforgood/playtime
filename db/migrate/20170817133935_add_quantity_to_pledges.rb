class AddQuantityToPledges < ActiveRecord::Migration[5.1]
  def change
    add_column :pledges, :quantity, :integer, null: false, default: 1
  end
end
