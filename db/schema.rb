# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_12_14_180708) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "additional_documents", force: :cascade do |t|
    t.string "title"
    t.integer "position"
    t.text "description"
    t.bigint "practice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "attachment_file_name"
    t.string "attachment_content_type"
    t.integer "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.index ["practice_id"], name: "index_additional_documents_on_practice_id"
  end

  create_table "ancillary_service_practices", force: :cascade do |t|
    t.bigint "ancillary_service_id"
    t.bigint "practice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ancillary_service_id"], name: "index_ancillary_service_practices_on_ancillary_service_id"
    t.index ["practice_id"], name: "index_ancillary_service_practices_on_practice_id"
  end

  create_table "ancillary_services", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.text "description"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "badge_practices", force: :cascade do |t|
    t.bigint "badge_id"
    t.bigint "practice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["badge_id"], name: "index_badge_practices_on_badge_id"
    t.index ["practice_id"], name: "index_badge_practices_on_practice_id"
  end

  create_table "badges", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.text "description"
    t.integer "position"
    t.bigint "strategic_sponsor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "badge_image_file_name"
    t.string "badge_image_content_type"
    t.integer "badge_image_file_size"
    t.datetime "badge_image_updated_at"
    t.index ["strategic_sponsor_id"], name: "index_badges_on_strategic_sponsor_id"
  end

  create_table "business_case_files", force: :cascade do |t|
    t.string "title"
    t.integer "position"
    t.text "description"
    t.bigint "practice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "attachment_file_name"
    t.string "attachment_content_type"
    t.integer "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.index ["practice_id"], name: "index_business_case_files_on_practice_id"
  end

  create_table "clinical_condition_practices", force: :cascade do |t|
    t.bigint "clinical_condition_id"
    t.bigint "practice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["clinical_condition_id"], name: "index_clinical_condition_practices_on_clinical_condition_id"
    t.index ["practice_id"], name: "index_clinical_condition_practices_on_practice_id"
  end

  create_table "clinical_conditions", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.text "description"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clinical_location_practices", force: :cascade do |t|
    t.bigint "clinical_location_id"
    t.bigint "practice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["clinical_location_id"], name: "index_clinical_location_practices_on_clinical_location_id"
    t.index ["practice_id"], name: "index_clinical_location_practices_on_practice_id"
  end

  create_table "clinical_locations", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.text "description"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "impact_categories", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.text "description"
    t.integer "position"
    t.integer "parent_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "impact_practices", force: :cascade do |t|
    t.bigint "impact_id"
    t.bigint "practice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["impact_id"], name: "index_impact_practices_on_impact_id"
    t.index ["practice_id"], name: "index_impact_practices_on_practice_id"
  end

  create_table "impacts", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.text "description"
    t.integer "position"
    t.bigint "impact_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["impact_category_id"], name: "index_impacts_on_impact_category_id"
  end

  create_table "implementation_timeline_files", force: :cascade do |t|
    t.string "title"
    t.integer "position"
    t.text "description"
    t.bigint "practice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "attachment_file_name"
    t.string "attachment_content_type"
    t.integer "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.index ["practice_id"], name: "index_implementation_timeline_files_on_practice_id"
  end

  create_table "job_position_categories", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.text "description"
    t.integer "position"
    t.integer "parent_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "job_position_practices", force: :cascade do |t|
    t.bigint "job_position_id"
    t.bigint "practice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_position_id"], name: "index_job_position_practices_on_job_position_id"
    t.index ["practice_id"], name: "index_job_position_practices_on_practice_id"
  end

  create_table "job_positions", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.text "description"
    t.integer "position"
    t.bigint "job_position_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_position_category_id"], name: "index_job_positions_on_job_position_category_id"
  end

  create_table "photo_files", force: :cascade do |t|
    t.string "title"
    t.integer "position"
    t.text "description"
    t.bigint "practice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "attachment_file_name"
    t.string "attachment_content_type"
    t.integer "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.index ["practice_id"], name: "index_photo_files_on_practice_id"
  end

  create_table "practices", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.text "description"
    t.integer "position"
    t.boolean "is_vha_field"
    t.boolean "is_program_office"
    t.string "vha_visn"
    t.string "medical_center"
    t.text "business_case_summary"
    t.string "support_network_email"
    t.string "va_pulse_link"
    t.text "additional_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "main_display_image_file_name"
    t.string "main_display_image_content_type"
    t.integer "main_display_image_file_size"
    t.datetime "main_display_image_updated_at"
  end

  create_table "publication_files", force: :cascade do |t|
    t.string "title"
    t.integer "position"
    t.text "description"
    t.bigint "practice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "attachment_file_name"
    t.string "attachment_content_type"
    t.integer "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.index ["practice_id"], name: "index_publication_files_on_practice_id"
  end

  create_table "publications", force: :cascade do |t|
    t.string "title"
    t.string "link"
    t.integer "position"
    t.text "description"
    t.bigint "practice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["practice_id"], name: "index_publications_on_practice_id"
  end

  create_table "risk_and_mitigations", force: :cascade do |t|
    t.string "risk"
    t.string "mitigation"
    t.integer "position"
    t.text "description"
    t.bigint "practice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["practice_id"], name: "index_risk_and_mitigations_on_practice_id"
  end

  create_table "strategic_sponsor_practices", force: :cascade do |t|
    t.bigint "strategic_sponsor_id"
    t.bigint "practice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["practice_id"], name: "index_strategic_sponsor_practices_on_practice_id"
    t.index ["strategic_sponsor_id"], name: "index_strategic_sponsor_practices_on_strategic_sponsor_id"
  end

  create_table "strategic_sponsors", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.text "description"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "survey_result_files", force: :cascade do |t|
    t.string "title"
    t.integer "position"
    t.text "description"
    t.bigint "practice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "attachment_file_name"
    t.string "attachment_content_type"
    t.integer "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.index ["practice_id"], name: "index_survey_result_files_on_practice_id"
  end

  create_table "toolkit_files", force: :cascade do |t|
    t.string "title"
    t.integer "position"
    t.text "description"
    t.bigint "practice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "attachment_file_name"
    t.string "attachment_content_type"
    t.integer "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.index ["practice_id"], name: "index_toolkit_files_on_practice_id"
  end

  create_table "va_secretary_priorities", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.text "description"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "va_secretary_priority_practices", force: :cascade do |t|
    t.bigint "va_secretary_priority_id"
    t.bigint "practice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["practice_id"], name: "index_va_secretary_priority_practices_on_practice_id"
    t.index ["va_secretary_priority_id"], name: "idx_priority_practices_priority_id"
  end

  create_table "video_files", force: :cascade do |t|
    t.string "title"
    t.integer "position"
    t.text "description"
    t.bigint "practice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "attachment_file_name"
    t.string "attachment_content_type"
    t.integer "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.index ["practice_id"], name: "index_video_files_on_practice_id"
  end

  add_foreign_key "additional_documents", "practices"
  add_foreign_key "ancillary_service_practices", "ancillary_services"
  add_foreign_key "ancillary_service_practices", "practices"
  add_foreign_key "badge_practices", "badges"
  add_foreign_key "badge_practices", "practices"
  add_foreign_key "badges", "strategic_sponsors"
  add_foreign_key "business_case_files", "practices"
  add_foreign_key "clinical_condition_practices", "clinical_conditions"
  add_foreign_key "clinical_condition_practices", "practices"
  add_foreign_key "clinical_location_practices", "clinical_locations"
  add_foreign_key "clinical_location_practices", "practices"
  add_foreign_key "impact_practices", "impacts"
  add_foreign_key "impact_practices", "practices"
  add_foreign_key "impacts", "impact_categories"
  add_foreign_key "implementation_timeline_files", "practices"
  add_foreign_key "job_position_practices", "job_positions"
  add_foreign_key "job_position_practices", "practices"
  add_foreign_key "job_positions", "job_position_categories"
  add_foreign_key "photo_files", "practices"
  add_foreign_key "publication_files", "practices"
  add_foreign_key "publications", "practices"
  add_foreign_key "risk_and_mitigations", "practices"
  add_foreign_key "strategic_sponsor_practices", "practices"
  add_foreign_key "strategic_sponsor_practices", "strategic_sponsors"
  add_foreign_key "survey_result_files", "practices"
  add_foreign_key "toolkit_files", "practices"
  add_foreign_key "va_secretary_priority_practices", "practices"
  add_foreign_key "va_secretary_priority_practices", "va_secretary_priorities"
  add_foreign_key "video_files", "practices"
end
