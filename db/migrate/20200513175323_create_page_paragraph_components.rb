class CreatePageParagraphComponents < ActiveRecord::Migration[5.2]
  def change
    create_table :page_paragraph_components do |t|
      t.belongs_to :page_component, foreign_key: true
      t.string :text

      t.timestamps
    end
  end
end
