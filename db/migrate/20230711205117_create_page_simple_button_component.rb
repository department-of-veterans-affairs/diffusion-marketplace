class CreatePageSimpleButtonComponent < ActiveRecord::Migration[6.0]
  def change
    create_table :page_simple_button_components, id: :uuid do |t|
      t.belongs_to :page_component, foreign_key: true
      t.string :button_text
      t.string :url
      t.timestamps
    end
  end
end
