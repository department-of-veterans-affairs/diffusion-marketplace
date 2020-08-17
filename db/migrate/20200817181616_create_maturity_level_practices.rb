class CreateMaturityLevelPractices < ActiveRecord::Migration[5.2]
  def change
    create_table :maturity_level_practices do |t|
      t.belongs_to :maturity_level, foreign_key: true
      t.belongs_to :practice, foreign_key: true

      t.timestamps
    end
  end
end
