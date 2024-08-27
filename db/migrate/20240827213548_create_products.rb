class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :title
      t.string :tagline
      t.string :item_number
      t.string :vendor
      t.string :duns
      t.string :shipping_timeline_estimate
      t.string :origin_story
      t.text :description
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end

    add_attachment :products, :main_display_image
  end
end
