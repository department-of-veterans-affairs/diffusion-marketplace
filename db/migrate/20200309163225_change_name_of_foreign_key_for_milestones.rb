class ChangeNameOfForeignKeyForMilestones < ActiveRecord::Migration[5.2]
  def change
    rename_column :milestones, :timelines_id, :timeline_id
  end
end
