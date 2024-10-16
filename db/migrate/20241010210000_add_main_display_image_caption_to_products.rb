class AddMainDisplayImageCaptionToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :main_display_image_caption, :text
  end
end
