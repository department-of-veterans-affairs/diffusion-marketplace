class DropJobPosition < ActiveRecord::Migration[6.1]
  def change
    drop_table :job_position_categories, force: :cascade do |t|
      t.string "name"
      t.string "short_name"
      t.text "description"
      t.integer "position"
      t.integer "parent_category_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    drop_table :job_positions, force: :cascade do |t|
      t.string "name"
      t.string "short_name"
      t.text "description"
      t.integer "position"
      t.bigint "job_position_category_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["job_position_category_id"], name: "index_job_positions_on_job_position_category_id"
    end

    drop_table :job_position_practices, force: :cascade do |t|
      t.bigint "job_position_id"
      t.bigint "practice_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["job_position_id"], name: "index_job_position_practices_on_job_position_id"
      t.index ["practice_id"], name: "index_job_position_practices_on_practice_id"
    end
  end
end
