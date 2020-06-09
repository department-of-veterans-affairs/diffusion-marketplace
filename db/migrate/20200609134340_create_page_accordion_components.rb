class CreatePageAccordionComponents < ActiveRecord::Migration[5.2]
  def change
    create_table :page_accordion_components, id: :uuid do |t|
      t.belongs_to :page_component, foreign_key: true
      t.string :title
      t.string :text
      t.timestamps
    end
  end
end