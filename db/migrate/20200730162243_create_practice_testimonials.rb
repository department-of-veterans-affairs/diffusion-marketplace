class CreatePracticeTestimonials < ActiveRecord::Migration[5.2]
  def change
    create_table :practice_testimonials do |t|
      t.belongs_to :practice, foreign_key: true
      t.string :testimonial
      t.string :author
      t.timestamps
    end
  end
end