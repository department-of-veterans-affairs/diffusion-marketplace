# frozen_string_literal: true

class CreateTimelines < ActiveRecord::Migration[5.2]
  def change
    create_table :timelines do |t|
      t.string :description
      t.string :milestone
      t.string :timeline
      t.integer :position
      t.belongs_to :practice, foreign_key: true

      t.timestamps
    end
  end
end
