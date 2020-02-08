class AddIsMainDisplayImageToImpactPhotos < ActiveRecord::Migration[5.2]
  def change
    add_column :impact_photos, :is_main_display_image, :boolean, default: false
  end
end
