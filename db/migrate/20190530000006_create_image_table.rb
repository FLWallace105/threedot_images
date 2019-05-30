class CreateImageTable < ActiveRecord::Migration[5.2]
  def up
    create_table :product_image_files do |t|
      t.string :sku
      t.string :name
      t.datetime :downloaded_at
      t.boolean :is_downloaded, default: false
      t.string :base_image
      t.string :small_image
      t.string :thumbnail_image
      t.string :swatch_image

      

    end

  end

  def down
    drop_table :product_image_files

  end
end
