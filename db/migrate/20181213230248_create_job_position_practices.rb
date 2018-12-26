class CreateJobPositionPractices < ActiveRecord::Migration[5.2]
  def change
    create_table :job_position_practices do |t|
      t.belongs_to :job_position, foreign_key: true
      t.belongs_to :practice, foreign_key: true

      t.timestamps
    end
  end
end
