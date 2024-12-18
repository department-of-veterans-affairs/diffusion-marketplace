class DropClinicalLocations < ActiveRecord::Migration[6.1]
  def change
    drop_table :clinical_location_practices, force: :cascade do |t|
      t.bigint "clinical_location_id"
      t.bigint "practice_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["clinical_location_id"], name: "index_clinical_location_practices_on_clinical_location_id"
      t.index ["practice_id"], name: "index_clinical_location_practices_on_practice_id"
    end

    drop_table :clinical_locations, force: :cascade do |t|
      t.string "name"
      t.string "short_name"
      t.text "description"
      t.integer "position"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
