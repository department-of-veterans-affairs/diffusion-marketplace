class CreatePageCompoundBodyComponent < ActiveRecord::Migration[6.0]
  def change
    create_table :page_compound_body_components, id: :uuid do |t|
      t.belongs_to :page_component, foreign_key: true
      t.string :title
      t.text :text
      t.string :url
      t.timestamps
    end
  end
end
