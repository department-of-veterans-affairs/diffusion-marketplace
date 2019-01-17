class CreateBadges < ActiveRecord::Migration[5.2]
  def change
    create_table :badges do |t|
      t.string :name
      t.string :short_name
      t.text :description
      t.integer :position
      t.belongs_to :strategic_sponsor, foreign_key: true
      t.string :color
      t.string :icon

      t.timestamps
    end
  end
end
