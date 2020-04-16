class AddGoFishBadgeToBadges < ActiveRecord::Migration[5.2]
  def change
    Badge.create!({name: 'Go Fish'})
  end
end
