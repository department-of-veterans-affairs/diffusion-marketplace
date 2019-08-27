# frozen_string_literal: true

class CreateDevelopingFacilityTypePractices < ActiveRecord::Migration[5.2]
  def change
    create_table :developing_facility_type_practices do |t|
      t.belongs_to :practice, foreign_key: true
      t.belongs_to :developing_facility_type, index: { name: 'idx_developing_facility_practice_id' }, foreign_key: true

      t.timestamps
    end
  end
end
