# frozen_string_literal: true

class AddSlugToPractices < ActiveRecord::Migration[5.2]
  def change
    add_column :practices, :slug, :string
    add_index :practices, :slug, unique: true
    add_column :practice_partners, :slug, :string
    add_index :practice_partners, :slug, unique: true
  end
end
