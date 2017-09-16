class RemoveSiteManagerFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :site_manager, :boolean
  end
end
