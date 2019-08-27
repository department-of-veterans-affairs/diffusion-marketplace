# frozen_string_literal: true

class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string :name
      t.string :short_name
      t.text :description
      t.integer :position
      t.integer :parent_category_id, references: :category, foreign_key: true

      t.timestamps
    end
  end
end
