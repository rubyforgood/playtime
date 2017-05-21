class CreatePledges < ActiveRecord::Migration[5.1]
  def change
    create_table :pledges do |t|
      t.integer :item_id
      t.integer :user_id

      t.timestamps
    end
  end
end
