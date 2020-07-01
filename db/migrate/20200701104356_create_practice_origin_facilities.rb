class CreatePracticeOriginFacilities < ActiveRecord::Migration[5.2]
  def change
    create_table :practice_origin_facilities do |t|
      t.belongs_to :practice, foreign_key: true
      t.string :facility_id
      t.integer :facility_type, default: 0
      t.timestamps
    end
  end
end