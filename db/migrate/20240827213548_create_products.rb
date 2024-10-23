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
      t.string :usage
      t.string :price
      t.text :description
      t.text :main_display_image_caption
      t.text :main_display_image_alt_text
      t.string :support_network_email
      t.string :slug
      t.string :vendor_link
      t.boolean :private_contact_info
      t.boolean :published, default: false
      t.boolean :retired, default: false
      t.datetime :date_published
      t.references :user, null: true, foreign_key: true

      t.integer :crop_x
      t.integer :crop_y
      t.integer :crop_w
      t.integer :crop_h

      t.timestamps
    end

    add_attachment :products, :main_display_image
    add_index :products, :name, unique: true
    add_index :products, :slug, unique: true
  end
end
