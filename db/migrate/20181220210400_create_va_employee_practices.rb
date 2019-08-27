# frozen_string_literal: true

class CreateVaEmployeePractices < ActiveRecord::Migration[5.2]
  def change
    create_table :va_employee_practices do |t|
      t.integer :position
      t.belongs_to :practice, foreign_key: true
      t.belongs_to :va_employee, foreign_key: true

      t.timestamps
    end
  end
end
