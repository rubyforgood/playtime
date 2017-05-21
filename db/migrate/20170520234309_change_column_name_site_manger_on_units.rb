class ChangeColumnNameSiteMangerOnUnits < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :site_manger, :site_manager
  end
end
