# frozen_string_literal: true

class CreateRequiredStaffTrainings < ActiveRecord::Migration[5.2]
  def change
    create_table :required_staff_trainings do |t|
      t.string :title
      t.text :description
      t.integer :position
      t.belongs_to :practice, foreign_key: true

      t.timestamps
    end
  end
end
