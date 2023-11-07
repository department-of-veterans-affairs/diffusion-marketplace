class AddDateFieldsToPagePublicationComponent < ActiveRecord::Migration[6.0]
  def change
    add_column :page_publication_components, :published_on_month, :integer
    add_column :page_publication_components, :published_on_day, :integer
    add_column :page_publication_components, :published_on_year, :integer
  end
end
