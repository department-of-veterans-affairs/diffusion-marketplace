# frozen_string_literal: true

class CreateToolkitFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :toolkit_files do |t|
      t.string :title
      t.integer :position
      t.text :description
      t.belongs_to :practice, foreign_key: true

      t.timestamps
    end

    add_attachment :toolkit_files, :attachment
  end
end
