class RemoveDuplicateTimelineIdFromMilestones < ActiveRecord::Migration[5.2]
  def change
    remove_column :milestones, :timeline_id, :bigint
  end
end
