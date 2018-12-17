class CreatePhotoFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :photo_files do |t|
      t.string :title
      t.integer :position
      t.text :description
      t.belongs_to :practice, foreign_key: true

      t.timestamps
    end

    add_attachment :photo_files, :attachment
  end
end
