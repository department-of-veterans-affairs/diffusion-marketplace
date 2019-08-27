# frozen_string_literal: true

class CreateBadgePractices < ActiveRecord::Migration[5.2]
  def change
    create_table :badge_practices do |t|
      t.belongs_to :badge, foreign_key: true
      t.belongs_to :practice, foreign_key: true

      t.timestamps
    end
  end
end
