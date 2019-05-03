class CreateImpactPhotos < ActiveRecord::Migration[5.2]
  def change
    create_table :impact_photos do |t|
      t.string :title
      t.text :description
      t.integer :position
      t.belongs_to :practice, foreign_key: true

      t.integer :attachment_original_w
      t.integer :attachment_original_h
      t.integer :attachment_crop_x
      t.integer :attachment_crop_y
      t.integer :attachment_crop_w
      t.integer :attachment_crop_h

      t.timestamps
    end

    add_attachment :impact_photos, :attachment
  end
end
