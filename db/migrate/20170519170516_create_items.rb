class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.string :amazon_url
      t.string :associate_url
      t.integer :price_cents
      t.string :asin

      t.timestamps
    end
  end
end
