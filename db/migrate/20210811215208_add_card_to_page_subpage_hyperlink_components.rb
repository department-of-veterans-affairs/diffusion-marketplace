class AddCardToPageSubpageHyperlinkComponents < ActiveRecord::Migration[5.2]
  def change
    add_column :page_subpage_hyperlink_components, :card, :boolean, default: false
  end
end
