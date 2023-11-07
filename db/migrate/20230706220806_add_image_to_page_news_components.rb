class AddImageToPageNewsComponents < ActiveRecord::Migration[6.0]
  def change
    add_column :page_news_components, :image_alt_text, :text
    add_attachment :page_news_components, :image
  end
end
