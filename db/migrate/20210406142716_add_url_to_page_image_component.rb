class AddUrlToPageImageComponent < ActiveRecord::Migration[5.2]
  def change
    add_column :page_image_components, :url, :string
  end
end
