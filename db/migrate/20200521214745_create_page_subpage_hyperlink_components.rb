class CreatePageSubpageHyperlinkComponents < ActiveRecord::Migration[5.2]
  def change
    create_table :page_subpage_hyperlink_components do |t|
      t.belongs_to :page_component, foreign_key: true
      t.string :title
      t.string :description
      t.string :url
      t.timestamps
    end
  end
end
