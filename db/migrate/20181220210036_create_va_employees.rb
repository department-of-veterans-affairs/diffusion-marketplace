# frozen_string_literal: true

class CreateVaEmployees < ActiveRecord::Migration[5.2]
  def change
    create_table :va_employees do |t|
      t.string :name
      t.string :prefix
      t.string :suffix

      t.string :email
      t.text :bio

      t.string :job_title
      t.string :role

      t.integer :position

      t.timestamps
    end

    add_attachment :va_employees, :avatar
  end
end
