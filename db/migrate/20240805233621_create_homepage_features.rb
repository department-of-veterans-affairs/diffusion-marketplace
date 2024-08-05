class CreateHomepageFeatures < ActiveRecord::Migration[6.1]
  def change
    create_table :homepage_features do |t|
      t.string :title
      t.string :description
      t.string :url
      t.string :cta_text
      t.string :image_alt_text
      t.integer :section_id
      t.integer :position

      t.timestamps
    end
  end
end
