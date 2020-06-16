class AddTemplateTypeToPage < ActiveRecord::Migration[5.2]
  def change
    add_column :pages, :template_type, :integer, default: 0
  end
end
