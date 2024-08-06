class CreateHomepages < ActiveRecord::Migration[6.1]
  def change
    create_table :homepages do |t|
      t.string :internal_title
      t.string :section_title_one
      t.string :section_title_two
      t.string :section_title_three

      t.timestamps
    end

    create_table :homepage_features do |t|
      t.belongs_to :homepage, index: true
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

  def up
    add_attachment :homepage_features, :featured_image
  end

  def down
    remove_attachment :homepage_features, :featured_image
  end
end
