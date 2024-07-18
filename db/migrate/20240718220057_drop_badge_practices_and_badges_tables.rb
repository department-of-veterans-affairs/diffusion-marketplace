class DropBadgePracticesAndBadgesTables < ActiveRecord::Migration[6.1]
  def change
    drop_table :badge_practices
    drop_table :badges
  end
end
