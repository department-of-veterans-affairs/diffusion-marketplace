class CreateImpacts < ActiveRecord::Migration[5.2]
  def change
    create_table :impacts do |t|
      t.string :name
      t.string :short_name
      t.text :description
      t.integer :position
      t.belongs_to :impact_category, foreign_key: true

      t.timestamps
    end
  end
end
