class CreatePageHeader3Components < ActiveRecord::Migration[5.2]
  def change
    create_table :page_header3_components, id: :uuid do |t|
      t.belongs_to :page_component, foreign_key: true
      t.string :alignment
      t.string :title
      t.string :description
      t.timestamps
    end
  end
end