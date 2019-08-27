# frozen_string_literal: true

class CreateAdditionalStaffs < ActiveRecord::Migration[5.2]
  def change
    create_table :additional_staffs do |t|
      t.string :title
      t.string :hours_per_week
      t.string :duration_in_weeks
      t.boolean :permanent
      t.text :description
      t.integer :position
      t.belongs_to :practice, foreign_key: true

      t.timestamps
    end
  end
end
