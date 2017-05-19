class AddAmazonAuthFieldsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :amazon_user_id, :string
    add_column :users, :zipcode, :string

    add_index :users, :amazon_user_id, unique: true
  end
end
