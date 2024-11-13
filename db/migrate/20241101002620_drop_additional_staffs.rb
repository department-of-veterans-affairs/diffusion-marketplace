class DropAdditionalStaffs < ActiveRecord::Migration[6.1]
  def change
    drop_table :additional_staffs, force: :cascade do |t|
      t.string "title"
      t.string "hours_per_week"
      t.string "duration_in_weeks"
      t.boolean "permanent"
      t.text "description"
      t.integer "position"
      t.bigint "practice_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["practice_id"], name: "index_additional_staffs_on_practice_id"
    end
  end
end
