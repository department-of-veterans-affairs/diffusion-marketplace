class CreateMilestones < ActiveRecord::Migration[5.2]
  def change
    create_table :milestones do |t|
      t.string :description
      t.integer :position
      t.references :timelines, foreign_key: true
      t.bigint :timeline_id

      t.timestamps
    end
  end
end
