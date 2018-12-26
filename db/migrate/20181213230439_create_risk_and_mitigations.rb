class CreateRiskAndMitigations < ActiveRecord::Migration[5.2]
  def change
    create_table :risk_and_mitigations do |t|
      t.string :risk
      t.string :mitigation
      t.integer :position
      t.text :description
      t.belongs_to :practice, foreign_key: true

      t.timestamps
    end
  end
end
