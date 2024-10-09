class DropImpactPhotosTable < ActiveRecord::Migration[6.1]
  def change
    drop_table :impact_photos
  end
end
