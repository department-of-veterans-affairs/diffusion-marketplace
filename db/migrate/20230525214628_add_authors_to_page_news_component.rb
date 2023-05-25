class AddAuthorsToPageNewsComponent < ActiveRecord::Migration[6.0]
  def change
    add_column :page_news_components, :authors, :string
  end
end
