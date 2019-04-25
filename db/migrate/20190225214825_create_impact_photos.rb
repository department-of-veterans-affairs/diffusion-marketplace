class CreateImpactPhotos < ActiveRecord::Migration[5.2]
  def change
    create_table :impact_photos do |t|
      t.string :title
      t.text :description
      t.integer :position
      t.belongs_to :practice, foreign_key: true

      t.timestamps
    end

    add_attachment :impact_photos, :attachment
  end
end
