# frozen_string_literal: true

class CreateBusinessCaseFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :business_case_files do |t|
      t.string :title
      t.integer :position
      t.text :description
      t.belongs_to :practice, foreign_key: true

      t.timestamps
    end

    add_attachment :business_case_files, :attachment
  end
end
