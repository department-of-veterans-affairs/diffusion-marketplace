# frozen_string_literal: true

class CreatePublicationFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :publication_files do |t|
      t.string :title
      t.integer :position
      t.text :description
      t.belongs_to :practice, foreign_key: true

      t.timestamps
    end

    add_attachment :publication_files, :attachment
  end
end
