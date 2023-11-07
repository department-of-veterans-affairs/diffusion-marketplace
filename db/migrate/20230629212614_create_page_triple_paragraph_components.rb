class CreatePageTripleParagraphComponents < ActiveRecord::Migration[6.0]
  def change
    create_table :page_triple_paragraph_components, id: :uuid do |t|
      t.belongs_to :page_component, foreign_key: true
      t.string :title1
      t.text :text1
      t.string :title2
      t.text :text2
      t.string :title3
      t.text :text3
      t.boolean :has_background_color, default: false
      t.timestamps
    end
  end
end
