class CreateCommunities < ActiveRecord::Migration[6.0]
  def change
    create_table :communities do |t|
      t.string :name
      t.string :slug, unique: true
      t.string :distribution_email
      t.text :home_description
      t.string :intro_header
      t.text :intro_text
      t.string :external_url
      t.text :quote_text
      t.string :quote_name
      t.text :about_description
      t.text :leader_bio
      t.text :featured_practice_description
      t.timestamps
    end

    add_attachment :communities, :home_image
    add_attachment :communities, :featured_practice_image
  end
end
