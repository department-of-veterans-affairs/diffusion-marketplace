class CreatePracticeMetrics < ActiveRecord::Migration[5.2]
  def change
    create_table :practice_metrics do |t|
      t.string :description
      t.belongs_to :practice, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
