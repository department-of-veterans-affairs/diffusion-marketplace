class DropFinancialFiles < ActiveRecord::Migration[6.1]
  def change
    drop_table "financial_files" do |t|
      t.string "title"
      t.text "description"
      t.integer "position"
      t.bigint "practice_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "attachment_file_name"
      t.string "attachment_content_type"
      t.bigint "attachment_file_size"
      t.datetime "attachment_updated_at"
      t.index ["practice_id"], name: "index_financial_files_on_practice_id"
    end
  end
end
