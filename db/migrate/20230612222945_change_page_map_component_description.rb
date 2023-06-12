class ChangePageMapComponentDescription < ActiveRecord::Migration[6.0]
  def change
    change_column :page_map_components, :description, :text
  end
end
