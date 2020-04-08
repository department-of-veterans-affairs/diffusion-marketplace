class AddInetBadgeToBadges < ActiveRecord::Migration[5.2]
  def change
    Badge.create({name: 'iNET'})
  end
end
