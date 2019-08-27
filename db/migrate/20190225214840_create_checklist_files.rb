# frozen_string_literal: true

class CreateChecklistFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :checklist_files do |t|
      t.string :title
      t.text :description
      t.integer :position
      t.belongs_to :practice, foreign_key: true

      t.timestamps
    end

    add_attachment :checklist_files, :attachment
  end
end
