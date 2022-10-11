class AddImageAndImageAltTextToPages < ActiveRecord::Migration[6.0]
  def change
    add_column :pages, :image_alt_text, :text
    add_attachment :pages, :image
  end
end
