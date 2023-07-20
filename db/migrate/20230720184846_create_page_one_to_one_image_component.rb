class CreatePageOneToOneImageComponent < ActiveRecord::Migration[6.0]
  def change
    create_table :page_one_to_one_image_components, id: :uuid do |t|
      t.belongs_to :page_component, foreign_key: true
      t.string :title
      t.text :text
      t.string :url
      t.string :url_link_text
      t.string :text_alignment
      t.text :image_alt_text
      t.boolean :flipped_ratio, default: false
      t.timestamps
    end

    add_attachment :page_one_to_one_image_components, :image
  end
end
