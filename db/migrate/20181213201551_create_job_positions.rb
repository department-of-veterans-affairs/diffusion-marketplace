class CreateJobPositions < ActiveRecord::Migration[5.2]
  def change
    create_table :job_positions do |t|
      t.string :name
      t.string :short_name
      t.text :description
      t.integer :position
      t.belongs_to :job_position_category, foreign_key: true

      t.timestamps
    end
  end
end
