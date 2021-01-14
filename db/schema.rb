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

ActiveRecord::Schema.define(version: 2020_12_09_223407) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

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

  create_table "additional_resources", force: :cascade do |t|
    t.text "description"
    t.integer "position"
    t.bigint "practice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["practice_id"], name: "index_additional_resources_on_practice_id"
  end

  create_table "additional_staffs", force: :cascade do |t|
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

  create_table "ahoy_events", force: :cascade do |t|
    t.bigint "visit_id"
    t.bigint "user_id"
    t.string "name"
    t.jsonb "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["properties"], name: "index_ahoy_events_on_properties", opclass: :jsonb_path_ops, using: :gin
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.bigint "user_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.string "country"
    t.string "region"
    t.string "city"
    t.float "latitude"
    t.float "longitude"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.string "app_version"
    t.string "os_version"
    t.string "platform"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
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
    t.bigint "practice_partner_id"
    t.string "color"
    t.string "icon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["practice_partner_id"], name: "index_badges_on_practice_partner_id"
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

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.text "description"
    t.integer "position"
    t.integer "parent_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "related_terms", default: [], array: true
    t.boolean "is_other", default: false
  end

  create_table "category_practices", force: :cascade do |t|
    t.bigint "category_id"
    t.bigint "practice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_category_practices_on_category_id"
    t.index ["practice_id"], name: "index_category_practices_on_practice_id"
  end

  create_table "checklist_files", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "position"
    t.bigint "practice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "attachment_file_name"
    t.string "attachment_content_type"
    t.integer "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.index ["practice_id"], name: "index_checklist_files_on_practice_id"
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

  create_table "commontator_comments", force: :cascade do |t|
    t.bigint "thread_id", null: false
    t.string "creator_type", null: false
    t.bigint "creator_id", null: false
    t.string "editor_type"
    t.bigint "editor_id"
    t.text "body", null: false
    t.datetime "deleted_at"
    t.integer "cached_votes_up", default: 0
    t.integer "cached_votes_down", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "parent_id"
    t.index ["cached_votes_down"], name: "index_commontator_comments_on_cached_votes_down"
    t.index ["cached_votes_up"], name: "index_commontator_comments_on_cached_votes_up"
    t.index ["creator_id", "creator_type", "thread_id"], name: "index_commontator_comments_on_c_id_and_c_type_and_t_id"
    t.index ["editor_type", "editor_id"], name: "index_commontator_comments_on_editor_type_and_editor_id"
    t.index ["parent_id"], name: "index_commontator_comments_on_parent_id"
    t.index ["thread_id", "created_at"], name: "index_commontator_comments_on_thread_id_and_created_at"
  end

  create_table "commontator_subscriptions", force: :cascade do |t|
    t.bigint "thread_id", null: false
    t.string "subscriber_type", null: false
    t.bigint "subscriber_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subscriber_id", "subscriber_type", "thread_id"], name: "index_commontator_subscriptions_on_s_id_and_s_type_and_t_id", unique: true
    t.index ["thread_id"], name: "index_commontator_subscriptions_on_thread_id"
  end

  create_table "commontator_threads", force: :cascade do |t|
    t.string "commontable_type"
    t.bigint "commontable_id"
    t.string "closer_type"
    t.bigint "closer_id"
    t.datetime "closed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["closer_type", "closer_id"], name: "index_commontator_threads_on_closer_type_and_closer_id"
    t.index ["commontable_type", "commontable_id"], name: "index_commontator_threads_on_c_id_and_c_type", unique: true
  end

  create_table "costs", force: :cascade do |t|
    t.string "description"
    t.integer "position"
    t.bigint "practice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["practice_id"], name: "index_costs_on_practice_id"
  end

  create_table "department_practices", force: :cascade do |t|
    t.bigint "practice_id"
    t.bigint "department_id"
    t.boolean "is_primary", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_department_practices_on_department_id"
    t.index ["practice_id"], name: "index_department_practices_on_practice_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.text "description"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "developing_facility_type_practices", force: :cascade do |t|
    t.bigint "practice_id"
    t.bigint "developing_facility_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["developing_facility_type_id"], name: "idx_developing_facility_practice_id"
    t.index ["practice_id"], name: "index_developing_facility_type_practices_on_practice_id"
  end

  create_table "developing_facility_types", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.integer "position"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "difficulties", force: :cascade do |t|
    t.string "description"
    t.integer "position"
    t.bigint "practice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["practice_id"], name: "index_difficulties_on_practice_id"
  end

  create_table "diffusion_histories", force: :cascade do |t|
    t.bigint "practice_id"
    t.string "facility_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["practice_id"], name: "index_diffusion_histories_on_practice_id"
  end

  create_table "diffusion_history_statuses", force: :cascade do |t|
    t.bigint "diffusion_history_id"
    t.string "status"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["diffusion_history_id"], name: "index_diffusion_history_statuses_on_diffusion_history_id"
  end

  create_table "domain_practices", force: :cascade do |t|
    t.bigint "domain_id"
    t.bigint "practice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["domain_id"], name: "index_domain_practices_on_domain_id"
    t.index ["practice_id"], name: "index_domain_practices_on_practice_id"
  end

  create_table "domains", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.text "description"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "financial_files", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "position"
    t.bigint "practice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "attachment_file_name"
    t.string "attachment_content_type"
    t.integer "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.index ["practice_id"], name: "index_financial_files_on_practice_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "impact_photos", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "position"
    t.bigint "practice_id"
    t.integer "attachment_original_w"
    t.integer "attachment_original_h"
    t.integer "attachment_crop_x"
    t.integer "attachment_crop_y"
    t.integer "attachment_crop_w"
    t.integer "attachment_crop_h"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "attachment_file_name"
    t.string "attachment_content_type"
    t.integer "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.boolean "is_main_display_image", default: false
    t.index ["practice_id"], name: "index_impact_photos_on_practice_id"
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

  create_table "milestones", force: :cascade do |t|
    t.string "description"
    t.integer "position"
    t.bigint "timeline_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["timeline_id"], name: "index_milestones_on_timeline_id"
  end

  create_table "mitigations", force: :cascade do |t|
    t.string "description"
    t.integer "position"
    t.bigint "risk_mitigation_id"
    t.index ["risk_mitigation_id"], name: "index_mitigations_on_risk_mitigation_id"
  end

  create_table "old_passwords", force: :cascade do |t|
    t.string "encrypted_password", null: false
    t.string "password_archivable_type", null: false
    t.integer "password_archivable_id", null: false
    t.string "password_salt"
    t.datetime "created_at"
    t.index ["password_archivable_type", "password_archivable_id"], name: "index_password_archivable"
  end

  create_table "page_accordion_components", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "page_component_id"
    t.string "title"
    t.string "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_component_id"], name: "index_page_accordion_components_on_page_component_id"
  end

  create_table "page_components", force: :cascade do |t|
    t.bigint "page_id"
    t.integer "position"
    t.string "component_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "component_id", null: false
    t.index ["component_id"], name: "index_page_components_on_component_id"
    t.index ["page_id"], name: "index_page_components_on_page_id"
    t.index ["position"], name: "index_page_components_on_position"
  end

  create_table "page_cta_components", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "page_component_id"
    t.text "cta_text"
    t.string "button_text"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_component_id"], name: "index_page_cta_components_on_page_component_id"
  end

  create_table "page_downloadable_file_components", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "page_component_id"
    t.string "display_name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "attachment_file_name"
    t.string "attachment_content_type"
    t.integer "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.index ["page_component_id"], name: "index_page_downloadable_file_components_on_page_component_id"
  end

  create_table "page_groups", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_page_groups_on_slug", unique: true
  end

  create_table "page_header2_components", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "page_component_id"
    t.string "subtopic_title"
    t.string "subtopic_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_component_id"], name: "index_page_header2_components_on_page_component_id"
  end

  create_table "page_header3_components", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "page_component_id"
    t.string "alignment"
    t.string "title"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_component_id"], name: "index_page_header3_components_on_page_component_id"
  end

  create_table "page_header_components", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "page_component_id"
    t.string "text"
    t.string "heading_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_component_id"], name: "index_page_header_components_on_page_component_id"
  end

  create_table "page_hr_components", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "page_component_id"
    t.string "html_tag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_component_id"], name: "index_page_hr_components_on_page_component_id"
  end

  create_table "page_image_components", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "page_component_id"
    t.text "alt_text"
    t.string "alignment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "page_image_file_name"
    t.string "page_image_content_type"
    t.integer "page_image_file_size"
    t.datetime "page_image_updated_at"
    t.index ["page_component_id"], name: "index_page_image_components_on_page_component_id"
  end

  create_table "page_paragraph_components", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "page_component_id"
    t.string "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_component_id"], name: "index_page_paragraph_components_on_page_component_id"
  end

  create_table "page_practice_list_components", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "practices", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "page_subpage_hyperlink_components", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "page_component_id"
    t.string "title"
    t.string "description"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_component_id"], name: "index_page_subpage_hyperlink_components_on_page_component_id"
  end

  create_table "page_you_tube_player_components", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "page_component_id"
    t.string "url"
    t.string "caption"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_component_id"], name: "index_page_you_tube_player_components_on_page_component_id"
  end

  create_table "pages", force: :cascade do |t|
    t.bigint "page_group_id"
    t.string "title"
    t.string "description"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "published"
    t.boolean "ever_published", default: false, null: false
    t.boolean "is_visible", default: true, null: false
    t.integer "template_type", default: 0
    t.boolean "has_chrome_warning_banner", default: false
    t.index ["page_group_id"], name: "index_pages_on_page_group_id"
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

  create_table "practice_awards", force: :cascade do |t|
    t.bigint "practice_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["practice_id"], name: "index_practice_awards_on_practice_id"
  end

  create_table "practice_creators", force: :cascade do |t|
    t.bigint "practice_id"
    t.bigint "user_id"
    t.string "role"
    t.string "name"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.index ["practice_id"], name: "index_practice_creators_on_practice_id"
    t.index ["user_id"], name: "index_practice_creators_on_user_id"
  end

  create_table "practice_emails", force: :cascade do |t|
    t.bigint "practice_id"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["practice_id"], name: "index_practice_emails_on_practice_id"
  end

  create_table "practice_management_practices", force: :cascade do |t|
    t.bigint "practice_id"
    t.bigint "practice_management_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["practice_id"], name: "index_practice_management_practices_on_practice_id"
    t.index ["practice_management_id"], name: "index_practice_management_practices_on_practice_management_id"
  end

  create_table "practice_managements", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.text "description"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "practice_metrics", force: :cascade do |t|
    t.string "description"
    t.bigint "practice_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["practice_id"], name: "index_practice_metrics_on_practice_id"
  end

  create_table "practice_multimedia", force: :cascade do |t|
    t.bigint "practice_id"
    t.string "link_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "attachment_file_name"
    t.string "attachment_content_type"
    t.integer "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.string "name"
    t.string "description"
    t.integer "position"
    t.integer "resource_type", default: 0
    t.index ["practice_id"], name: "index_practice_multimedia_on_practice_id"
  end

  create_table "practice_origin_facilities", force: :cascade do |t|
    t.bigint "practice_id"
    t.string "facility_id"
    t.integer "facility_type", default: 0
    t.integer "initiating_department_office_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["practice_id"], name: "index_practice_origin_facilities_on_practice_id"
  end

  create_table "practice_partner_practices", force: :cascade do |t|
    t.bigint "practice_partner_id"
    t.bigint "practice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["practice_id"], name: "index_practice_partner_practices_on_practice_id"
    t.index ["practice_partner_id"], name: "index_practice_partner_practices_on_practice_partner_id"
  end

  create_table "practice_partners", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.text "description"
    t.integer "position"
    t.string "color"
    t.string "icon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["slug"], name: "index_practice_partners_on_slug", unique: true
  end

  create_table "practice_permissions", force: :cascade do |t|
    t.integer "position"
    t.string "description"
    t.bigint "practice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["practice_id"], name: "index_practice_permissions_on_practice_id"
  end

  create_table "practice_problem_resources", force: :cascade do |t|
    t.bigint "practice_id"
    t.string "link_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "attachment_file_name"
    t.string "attachment_content_type"
    t.integer "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.string "name"
    t.string "description"
    t.integer "position"
    t.integer "resource_type", default: 0
    t.index ["practice_id"], name: "index_practice_problem_resources_on_practice_id"
  end

  create_table "practice_resources", force: :cascade do |t|
    t.bigint "practice_id"
    t.string "link_url"
    t.string "resource"
    t.string "name"
    t.string "description"
    t.integer "resource_type"
    t.integer "media_type"
    t.integer "resource_type_label"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "attachment_file_name"
    t.string "attachment_content_type"
    t.integer "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.index ["practice_id"], name: "index_practice_resources_on_practice_id"
  end

  create_table "practice_results_resources", force: :cascade do |t|
    t.bigint "practice_id"
    t.string "link_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "attachment_file_name"
    t.string "attachment_content_type"
    t.integer "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.string "name"
    t.string "description"
    t.integer "position"
    t.integer "resource_type", default: 0
    t.index ["practice_id"], name: "index_practice_results_resources_on_practice_id"
  end

  create_table "practice_solution_resources", force: :cascade do |t|
    t.bigint "practice_id"
    t.string "link_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "attachment_file_name"
    t.string "attachment_content_type"
    t.integer "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.string "name"
    t.string "description"
    t.integer "position"
    t.integer "resource_type", default: 0
    t.index ["practice_id"], name: "index_practice_solution_resources_on_practice_id"
  end

  create_table "practice_testimonials", force: :cascade do |t|
    t.bigint "practice_id"
    t.string "testimonial"
    t.string "author"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["practice_id"], name: "index_practice_testimonials_on_practice_id"
  end

  create_table "practices", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.text "description"
    t.integer "position"
    t.string "cboc"
    t.string "program_office"
    t.string "initiating_facility"
    t.string "vha_visn"
    t.string "medical_center"
    t.integer "number_adopted", default: 0
    t.integer "number_failed", default: 0
    t.text "business_case_summary"
    t.string "support_network_email"
    t.string "va_pulse_link"
    t.text "additional_notes"
    t.datetime "date_initiated"
    t.text "impact_veteran_experience"
    t.text "impact_veteran_satisfaction"
    t.text "impact_other_veteran_experience"
    t.text "impact_financial_estimate_saved"
    t.text "impact_financial_per_veteran"
    t.text "impact_financial_roi"
    t.text "impact_financial_other"
    t.string "phase_gate"
    t.string "successful_implementation"
    t.string "target_measures"
    t.integer "target_success"
    t.string "implementation_time_estimate"
    t.string "implementation_time_estimate_description"
    t.text "implentation_summary"
    t.text "implementation_fte"
    t.string "tagline"
    t.string "gold_status_tagline"
    t.string "summary"
    t.integer "risk_level_aggregate", default: 0
    t.integer "cost_savings_aggregate", default: 0
    t.integer "cost_to_implement_aggregate", default: 0
    t.integer "veteran_satisfaction_aggregate", default: 0
    t.integer "difficulty_aggregate", default: 0
    t.integer "sustainability_aggregate", default: 0
    t.string "origin_title"
    t.string "origin_story"
    t.boolean "need_additional_staff"
    t.boolean "need_training"
    t.boolean "need_policy_change"
    t.boolean "need_new_license"
    t.boolean "training_test"
    t.boolean "training_test_details"
    t.string "training_provider"
    t.text "required_training_summary"
    t.string "training_length"
    t.string "facility_complexity_level"
    t.integer "main_display_image_original_w"
    t.integer "main_display_image_original_h"
    t.integer "main_display_image_crop_x"
    t.integer "main_display_image_crop_y"
    t.integer "main_display_image_crop_w"
    t.integer "main_display_image_crop_h"
    t.integer "origin_picture_original_w"
    t.integer "origin_picture_original_h"
    t.integer "origin_picture_crop_x"
    t.integer "origin_picture_crop_y"
    t.integer "origin_picture_crop_w"
    t.integer "origin_picture_crop_h"
    t.integer "number_departments", default: 0
    t.boolean "it_required"
    t.string "process"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "main_display_image_file_name"
    t.string "main_display_image_content_type"
    t.integer "main_display_image_file_size"
    t.datetime "main_display_image_updated_at"
    t.string "origin_picture_file_name"
    t.string "origin_picture_content_type"
    t.integer "origin_picture_file_size"
    t.datetime "origin_picture_updated_at"
    t.bigint "user_id"
    t.boolean "published", default: false
    t.boolean "approved", default: false
    t.string "slug"
    t.boolean "highlight", default: false, null: false
    t.boolean "featured", default: false, null: false
    t.integer "ahoy_visit_id"
    t.string "training_provider_role"
    t.boolean "enabled", default: true, null: false
    t.integer "initiating_facility_type", default: 0
    t.integer "initiating_department_office_id"
    t.string "overview_problem"
    t.string "overview_solution"
    t.string "overview_results"
    t.integer "maturity_level"
    t.datetime "date_published"
    t.datetime "practice_pages_updated"
    t.string "highlight_title"
    t.string "highlight_body"
    t.index ["slug"], name: "index_practices_on_slug", unique: true
    t.index ["user_id"], name: "index_practices_on_user_id"
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

  create_table "required_staff_trainings", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "position"
    t.bigint "practice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["practice_id"], name: "index_required_staff_trainings_on_practice_id"
  end

  create_table "risk_mitigations", force: :cascade do |t|
    t.integer "position"
    t.bigint "practice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["practice_id"], name: "index_risk_mitigations_on_practice_id"
  end

  create_table "risks", force: :cascade do |t|
    t.string "description"
    t.integer "position"
    t.bigint "risk_mitigation_id"
    t.index ["risk_mitigation_id"], name: "index_risks_on_risk_mitigation_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
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

  create_table "timelines", force: :cascade do |t|
    t.string "description"
    t.string "milestone"
    t.string "timeline"
    t.integer "position"
    t.bigint "practice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["practice_id"], name: "index_timelines_on_practice_id"
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

  create_table "user_practices", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "practice_id"
    t.boolean "committed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "favorited", default: false
    t.boolean "verified_implementer", default: false
    t.boolean "team_member", default: false
    t.datetime "time_favorited"
    t.datetime "time_committed"
    t.index ["practice_id"], name: "index_user_practices_on_practice_id"
    t.index ["user_id"], name: "index_user_practices_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "job_title"
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.integer "visn"
    t.datetime "password_changed_at"
    t.boolean "skip_va_validation", default: false, null: false
    t.boolean "disabled", default: false, null: false
    t.text "bio"
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string "location"
    t.string "facility"
    t.boolean "accepted_terms", default: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["password_changed_at"], name: "index_users_on_password_changed_at"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  create_table "va_employee_practices", force: :cascade do |t|
    t.integer "position"
    t.bigint "practice_id"
    t.bigint "va_employee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["practice_id"], name: "index_va_employee_practices_on_practice_id"
    t.index ["va_employee_id"], name: "index_va_employee_practices_on_va_employee_id"
  end

  create_table "va_employees", force: :cascade do |t|
    t.string "name"
    t.string "prefix"
    t.string "suffix"
    t.string "email"
    t.text "bio"
    t.string "job_title"
    t.string "role"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
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

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "video_files", force: :cascade do |t|
    t.string "title"
    t.integer "position"
    t.string "url"
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

  create_table "votes", id: :serial, force: :cascade do |t|
    t.string "votable_type"
    t.integer "votable_id"
    t.string "voter_type"
    t.integer "voter_id"
    t.boolean "vote_flag"
    t.string "vote_scope"
    t.integer "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope"
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope"
  end

  add_foreign_key "additional_documents", "practices"
  add_foreign_key "additional_resources", "practices"
  add_foreign_key "additional_staffs", "practices"
  add_foreign_key "ancillary_service_practices", "ancillary_services"
  add_foreign_key "ancillary_service_practices", "practices"
  add_foreign_key "badge_practices", "badges"
  add_foreign_key "badge_practices", "practices"
  add_foreign_key "badges", "practice_partners"
  add_foreign_key "business_case_files", "practices"
  add_foreign_key "category_practices", "categories"
  add_foreign_key "category_practices", "practices"
  add_foreign_key "checklist_files", "practices"
  add_foreign_key "clinical_condition_practices", "clinical_conditions"
  add_foreign_key "clinical_condition_practices", "practices"
  add_foreign_key "clinical_location_practices", "clinical_locations"
  add_foreign_key "clinical_location_practices", "practices"
  add_foreign_key "commontator_comments", "commontator_comments", column: "parent_id", on_update: :restrict, on_delete: :cascade
  add_foreign_key "commontator_comments", "commontator_threads", column: "thread_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "commontator_subscriptions", "commontator_threads", column: "thread_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "costs", "practices"
  add_foreign_key "department_practices", "departments"
  add_foreign_key "department_practices", "practices"
  add_foreign_key "developing_facility_type_practices", "developing_facility_types"
  add_foreign_key "developing_facility_type_practices", "practices"
  add_foreign_key "difficulties", "practices"
  add_foreign_key "diffusion_histories", "practices"
  add_foreign_key "diffusion_history_statuses", "diffusion_histories"
  add_foreign_key "domain_practices", "domains"
  add_foreign_key "domain_practices", "practices"
  add_foreign_key "financial_files", "practices"
  add_foreign_key "impact_photos", "practices"
  add_foreign_key "implementation_timeline_files", "practices"
  add_foreign_key "job_position_practices", "job_positions"
  add_foreign_key "job_position_practices", "practices"
  add_foreign_key "job_positions", "job_position_categories"
  add_foreign_key "milestones", "timelines"
  add_foreign_key "mitigations", "risk_mitigations"
  add_foreign_key "page_accordion_components", "page_components"
  add_foreign_key "page_components", "pages"
  add_foreign_key "page_cta_components", "page_components"
  add_foreign_key "page_downloadable_file_components", "page_components"
  add_foreign_key "page_header2_components", "page_components"
  add_foreign_key "page_header3_components", "page_components"
  add_foreign_key "page_header_components", "page_components"
  add_foreign_key "page_hr_components", "page_components"
  add_foreign_key "page_image_components", "page_components"
  add_foreign_key "page_paragraph_components", "page_components"
  add_foreign_key "page_subpage_hyperlink_components", "page_components"
  add_foreign_key "page_you_tube_player_components", "page_components"
  add_foreign_key "pages", "page_groups"
  add_foreign_key "photo_files", "practices"
  add_foreign_key "practice_awards", "practices"
  add_foreign_key "practice_creators", "practices"
  add_foreign_key "practice_creators", "users"
  add_foreign_key "practice_emails", "practices"
  add_foreign_key "practice_management_practices", "practice_managements"
  add_foreign_key "practice_management_practices", "practices"
  add_foreign_key "practice_metrics", "practices"
  add_foreign_key "practice_multimedia", "practices"
  add_foreign_key "practice_origin_facilities", "practices"
  add_foreign_key "practice_partner_practices", "practice_partners"
  add_foreign_key "practice_partner_practices", "practices"
  add_foreign_key "practice_permissions", "practices"
  add_foreign_key "practice_problem_resources", "practices"
  add_foreign_key "practice_resources", "practices"
  add_foreign_key "practice_results_resources", "practices"
  add_foreign_key "practice_solution_resources", "practices"
  add_foreign_key "practice_testimonials", "practices"
  add_foreign_key "practices", "users"
  add_foreign_key "publication_files", "practices"
  add_foreign_key "publications", "practices"
  add_foreign_key "required_staff_trainings", "practices"
  add_foreign_key "risk_mitigations", "practices"
  add_foreign_key "risks", "risk_mitigations"
  add_foreign_key "survey_result_files", "practices"
  add_foreign_key "timelines", "practices"
  add_foreign_key "toolkit_files", "practices"
  add_foreign_key "user_practices", "practices"
  add_foreign_key "va_employee_practices", "practices"
  add_foreign_key "va_employee_practices", "va_employees"
  add_foreign_key "va_secretary_priority_practices", "practices"
  add_foreign_key "va_secretary_priority_practices", "va_secretary_priorities"
  add_foreign_key "video_files", "practices"
end
