class DropVaSecretaryPriorities < ActiveRecord::Migration[6.1]
  def change
    drop_table :va_secretary_priorities, force: :cascade do |t|
      t.string "name"
      t.string "short_name"
      t.text "description"
      t.integer "position"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    drop_table :va_secretary_priority_practices, force: :cascade do |t|
      t.bigint "va_secretary_priority_id"
      t.bigint "practice_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["practice_id"], name: "index_va_secretary_priority_practices_on_practice_id"
      t.index ["va_secretary_priority_id"], name: "idx_priority_practices_priority_id"
    end
  end
end
