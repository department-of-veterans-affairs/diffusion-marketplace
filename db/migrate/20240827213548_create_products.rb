class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :tagline
      t.string :item_number
      t.string :vendor
      t.string :duns
      t.string :shipping_timeline_estimate
      t.string :origin_story
      t.text :description
      t.text :main_display_image_alt_text
      t.references :user, null: true, foreign_key: true

      t.integer :crop_x
      t.integer :crop_y
      t.integer :crop_w
      t.integer :crop_h

      t.timestamps
    end

    add_attachment :products, :main_display_image
  end
end
