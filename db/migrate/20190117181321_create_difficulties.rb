# frozen_string_literal: true

class CreateDifficulties < ActiveRecord::Migration[5.2]
  def change
    create_table :difficulties do |t|
      t.string :description
      t.integer :position
      t.belongs_to :practice, foreign_key: true

      t.timestamps
    end
  end
end
