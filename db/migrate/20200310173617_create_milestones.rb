class CreateMilestones < ActiveRecord::Migration[5.2]
  def change
    create_table :milestones do |t|
      t.string :description
      t.integer :position
      t.belongs_to :timeline, foreign_key: true

      t.timestamps
    end
  end
end
