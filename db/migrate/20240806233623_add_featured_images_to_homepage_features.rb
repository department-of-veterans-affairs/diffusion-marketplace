class AddFeaturedImagesToHomepageFeatures < ActiveRecord::Migration[6.1]
  def up
    add_attachment :homepage_features, :featured_image
  end

  def down
    remove_attachment :homepage_features, :featured_image
  end
end
