class CreateHumanImpactPhotos < ActiveRecord::Migration[5.2]
  def change
    create_table :human_impact_photos do |t|
      t.string :title
      t.text :description
      t.integer :position
      t.belongs_to :practice, foreign_key: true

      t.timestamps
    end

    add_attachment :human_impact_photos, :attachment
  end
end
