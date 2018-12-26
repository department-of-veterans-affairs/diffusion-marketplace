class CreateDevelopingFacilityTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :developing_facility_types do |t|
      t.string :name
      t.string :short_name
      t.integer :position
      t.string :description

      t.timestamps
    end
  end
end
