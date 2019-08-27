# frozen_string_literal: true

class CreatePracticeManagementPractices < ActiveRecord::Migration[5.2]
  def change
    create_table :practice_management_practices do |t|
      t.belongs_to :practice, foreign_key: true
      t.belongs_to :practice_management, foreign_key: true

      t.timestamps
    end
  end
end
