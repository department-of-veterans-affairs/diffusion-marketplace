class CreateStrategicSponsors < ActiveRecord::Migration[5.2]
  def change
    create_table :strategic_sponsors do |t|
      t.string :name
      t.string :short_name
      t.text :description
      t.integer :position
      t.string :color
      t.string :icon

      t.timestamps
    end
  end
end
