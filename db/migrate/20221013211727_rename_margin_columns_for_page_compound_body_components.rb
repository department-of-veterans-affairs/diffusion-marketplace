class RenameMarginColumnsForPageCompoundBodyComponents < ActiveRecord::Migration[6.0]
  def change
    rename_column :page_compound_body_components, :margin_bottom, :padding_bottom
    rename_column :page_compound_body_components, :margin_top, :padding_top
  end
end
