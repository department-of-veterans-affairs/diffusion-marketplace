class AddUrlLinkTextToPageNewsComponents < ActiveRecord::Migration[6.1]
  def change
    add_column :page_news_components, :url_link_text, :string
  end
end
