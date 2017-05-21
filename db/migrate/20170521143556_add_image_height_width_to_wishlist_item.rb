class AddImageHeightWidthToWishlistItem < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :image_height, :integer
    add_column :items, :image_width, :integer
  end
end
