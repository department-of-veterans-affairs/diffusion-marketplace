class DropPracticeManagements < ActiveRecord::Migration[6.1]
  def change
    drop_table :practice_management_practices, force: :cascade do |t|
      t.bigint "practice_id"
      t.bigint "practice_management_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["practice_id"], name: "index_practice_management_practices_on_practice_id"
      t.index ["practice_management_id"], name: "index_practice_management_practices_on_practice_management_id"
    end

    drop_table :practice_managements, force: :cascade do |t|
      t.string "name"
      t.string "short_name"
      t.text "description"
      t.integer "position"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
