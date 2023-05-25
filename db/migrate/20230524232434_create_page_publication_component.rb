class CreatePagePublicationComponent < ActiveRecord::Migration[6.0]
  def change
    create_table :page_publication_components, id: :uuid do |t|
      t.belongs_to :page_component, foreign_key: true
      t.string :title
      t.string :authors
      t.string :url
      t.date :published_date
      t.string :published_in
      t.timestamps
    end
  end
end
