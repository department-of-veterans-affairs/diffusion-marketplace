class AddUrlLinkTextToPagePublicationComponent < ActiveRecord::Migration[6.1]
  def change
    add_column :page_publication_components, :url_link_text, :string
  end
end
