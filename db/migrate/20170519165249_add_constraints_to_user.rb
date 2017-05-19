class AddConstraintsToUser < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :email, :text, null: false
    change_column :users, :admin, :boolean, default: false

    add_index :users, :email, unique: true
  end
end
