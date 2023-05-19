class AddUrlToPageHeader3Component < ActiveRecord::Migration[6.0]
  def change
    add_column :page_header3_components, :url, :string
  end
end
