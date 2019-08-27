# frozen_string_literal: true

class CreateRiskAndMitigations < ActiveRecord::Migration[5.2]
  def change
    create_table :risk_mitigations do |t|
      t.integer :position
      t.belongs_to :practice, foreign_key: true

      t.timestamps
    end

    create_table :risks do |t|
      t.string :description
      t.integer :position
      t.belongs_to :risk_mitigation, foreign_key: true
    end

    create_table :mitigations do |t|
      t.string :description
      t.integer :position
      t.belongs_to :risk_mitigation, foreign_key: true
    end
  end
end
