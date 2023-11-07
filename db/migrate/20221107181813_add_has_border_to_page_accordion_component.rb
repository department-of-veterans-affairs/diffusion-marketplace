class AddHasBorderToPageAccordionComponent < ActiveRecord::Migration[6.0]
  def change
    add_column :page_accordion_components, :has_border, :boolean, default: false
  end
end
