class DropPracticeTestimonials < ActiveRecord::Migration[6.1]
  def change
    drop_table :practice_testimonials, force: :cascade do |t|
      t.bigint "practice_id"
      t.string "testimonial"
      t.string "author"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.integer "position"
      t.index ["practice_id"], name: "index_practice_testimonials_on_practice_id"
    end
  end
end
