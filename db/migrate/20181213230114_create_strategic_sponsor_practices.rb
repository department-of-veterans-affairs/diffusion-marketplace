class CreateStrategicSponsorPractices < ActiveRecord::Migration[5.2]
  def change
    create_table :strategic_sponsor_practices do |t|
      t.belongs_to :strategic_sponsor, foreign_key: true
      t.belongs_to :practice, foreign_key: true

      t.timestamps
    end
  end
end
