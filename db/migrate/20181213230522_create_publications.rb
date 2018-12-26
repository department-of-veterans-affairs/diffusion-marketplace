class CreatePublications < ActiveRecord::Migration[5.2]
  def change
    create_table :publications do |t|
      t.string :title
      t.string :link
      t.integer :position
      t.text :description
      t.belongs_to :practice, foreign_key: true

      t.timestamps
    end
  end
end
