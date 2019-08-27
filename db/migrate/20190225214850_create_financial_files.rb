# frozen_string_literal: true

class CreateFinancialFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :financial_files do |t|
      t.string :title
      t.text :description
      t.integer :position
      t.belongs_to :practice, foreign_key: true

      t.timestamps
    end

    add_attachment :financial_files, :attachment
  end
end
