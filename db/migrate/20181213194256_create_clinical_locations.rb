# frozen_string_literal: true

class CreateClinicalLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :clinical_locations do |t|
      t.string :name
      t.string :short_name
      t.text :description
      t.integer :position

      t.timestamps
    end
  end
end
