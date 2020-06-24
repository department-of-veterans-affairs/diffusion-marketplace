class CreatePracticeAwards < ActiveRecord::Migration[5.2]
  def change
    create_table :practice_awards do |t|
      t.belongs_to :practice, foreign_key: true
      t.string :name
      t.timestamps
    end
  end
end