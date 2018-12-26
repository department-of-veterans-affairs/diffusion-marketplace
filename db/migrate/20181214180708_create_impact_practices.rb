class CreateImpactPractices < ActiveRecord::Migration[5.2]
  def change
    create_table :impact_practices do |t|
      t.belongs_to :impact, foreign_key: true
      t.belongs_to :practice, foreign_key: true

      t.timestamps
    end
  end
end
