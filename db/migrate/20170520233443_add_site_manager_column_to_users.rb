class AddSiteManagerColumnToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :site_manger, :boolean
  end
end
