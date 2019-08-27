# frozen_string_literal: true

class CreateVaSecretaryPriorities < ActiveRecord::Migration[5.2]
  def change
    create_table :va_secretary_priorities do |t|
      t.string :name
      t.string :short_name
      t.text :description
      t.integer :position

      t.timestamps
    end
  end
end
