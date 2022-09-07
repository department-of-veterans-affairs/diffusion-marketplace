class CreatePageCompoundBodyComponent < ActiveRecord::Migration[6.0]
  def change
    create_table :page_compound_body_components, id: :uuid do |t|
      t.belongs_to :page_component, foreign_key: true
      t.string :title
      t.boolean :large_title, default: false
      t.text :text
      t.string :url
      t.string :url_link_text
      t.string :title_header
      t.string :text_alignment
      t.timestamps
    end
  end
end
