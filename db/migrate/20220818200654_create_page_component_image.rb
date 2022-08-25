class CreatePageComponentImage < ActiveRecord::Migration[6.0]
  def change
    create_table :page_component_images do |t|
      t.belongs_to :page_component, foreign_key: true
      t.text :caption
      t.text :alt_text
      t.timestamps
    end
    add_attachment :page_component_images, :image
  end
end
