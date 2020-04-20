class AddSharkTankBadgeToBadges < ActiveRecord::Migration[5.2]
  def change
    Badge.create!({name: 'Shark Tank'})
  end
end
