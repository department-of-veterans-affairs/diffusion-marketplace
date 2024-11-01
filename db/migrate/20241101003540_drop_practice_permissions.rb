class DropPracticePermissions < ActiveRecord::Migration[6.1]
  def change
      drop_table :practice_permissions, force: :cascade do |t|
        t.integer "position"
        t.string "description"
        t.bigint "practice_id"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.string "name"
        t.index ["practice_id"], name: "index_practice_permissions_on_practice_id"
      end
  end
end
