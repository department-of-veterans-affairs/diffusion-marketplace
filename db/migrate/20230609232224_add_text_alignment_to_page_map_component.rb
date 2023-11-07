class AddTextAlignmentToPageMapComponent < ActiveRecord::Migration[6.0]
  def change
    add_column :page_map_components, :description_text_alignment, :string
  end
end
