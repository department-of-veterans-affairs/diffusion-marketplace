class CreatePageComponents < ActiveRecord::Migration[5.2]
  def change
    create_table :page_components do |t|
      t.belongs_to :page, foreign_key: true
      t.integer :position
      t.integer :component_id
      t.string :component_type
      t.timestamps
    end
  end
end
