class AddColumnsToItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :image_url, :string
    add_column :items, :staff_message, :text
  end
end
