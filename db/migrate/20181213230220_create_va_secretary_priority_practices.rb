# frozen_string_literal: true

class CreateVaSecretaryPriorityPractices < ActiveRecord::Migration[5.2]
  def change
    create_table :va_secretary_priority_practices do |t|
      t.belongs_to :va_secretary_priority, index: { name: 'idx_priority_practices_priority_id' }, foreign_key: true
      t.belongs_to :practice, foreign_key: true

      t.timestamps
    end
  end
end
