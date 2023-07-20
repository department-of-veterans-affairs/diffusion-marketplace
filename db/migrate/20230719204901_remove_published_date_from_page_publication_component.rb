class RemovePublishedDateFromPagePublicationComponent < ActiveRecord::Migration[6.0]
  def change
    remove_column :page_publication_components, :published_date, :date
  end
end
