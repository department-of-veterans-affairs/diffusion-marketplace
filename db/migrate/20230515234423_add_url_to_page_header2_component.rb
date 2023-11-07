class AddUrlToPageHeader2Component < ActiveRecord::Migration[6.0]
  def change
    add_column :page_header2_components, :url, :string
  end
end
