class AddHasBackgroundColorToPageCtaComponents < ActiveRecord::Migration[6.0]
  def change
    add_column :page_cta_components, :has_background_color, :boolean, default: false
  end
end
