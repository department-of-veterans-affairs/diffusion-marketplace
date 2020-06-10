class CreatePageImageComponent < ActiveRecord::Migration[5.2]
  def change
    create_table :page_image_components, id: :uuid do |t|
      t.belongs_to :page_component, foreign_key: true
      t.text :alt_text
      t.string :alignment
      t.timestamps
    end

    add_attachment :page_image_components, :page_image
  end
end
