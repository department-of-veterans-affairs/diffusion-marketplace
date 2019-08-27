# frozen_string_literal: true

class CreateVideoFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :video_files do |t|
      t.string :title
      t.integer :position
      t.string :url
      t.text :description
      t.belongs_to :practice, foreign_key: true

      t.timestamps
    end

    add_attachment :video_files, :attachment
  end
end
