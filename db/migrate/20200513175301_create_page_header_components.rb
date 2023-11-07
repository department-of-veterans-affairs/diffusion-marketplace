class CreatePageHeaderComponents < ActiveRecord::Migration[5.2]
  def change
    create_table :page_header_components do |t|
      t.belongs_to :page_component, foreign_key: true
      t.string :text
      t.string :heading_type
      t.timestamps
    end
  end
end
