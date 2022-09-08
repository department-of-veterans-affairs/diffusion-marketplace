class CreatePageMapComponents < ActiveRecord::Migration[5.2]
  def change
    create_table :page_map_components, id: :uuid do |t|
      t.belongs_to :page_component, foreign_key: true
      t.string :title
      t.string :short_name
      t.string :description
      t.string :practices, array: true, default: []
      t.boolean :display_successful, default: false
      t.boolean :display_in_progress, default: false
      t.boolean :display_unsuccessful, default: false
      t.timestamps
    end
  end
end