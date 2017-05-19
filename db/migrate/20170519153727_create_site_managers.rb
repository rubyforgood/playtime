class CreateSiteManagers < ActiveRecord::Migration[5.1]
  def change
    create_table :site_managers do |t|
      t.integer :user_id
      t.integer :wishlist_id

      t.timestamps
    end
  end
end
