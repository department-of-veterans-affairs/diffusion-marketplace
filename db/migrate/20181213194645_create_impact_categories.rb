class CreateImpactCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :impact_categories do |t|
      t.string :name
      t.string :short_name
      t.text :description
      t.integer :position
      t.integer :parent_category_id, references: :impact_category, foreign_key: true

      t.timestamps
    end
  end
end
