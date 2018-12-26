class CreateClinicalLocationPractices < ActiveRecord::Migration[5.2]
  def change
    create_table :clinical_location_practices do |t|
      t.belongs_to :clinical_location, foreign_key: true
      t.belongs_to :practice, foreign_key: true

      t.timestamps
    end
  end
end
