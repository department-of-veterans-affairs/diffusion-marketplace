class AddPublicToPages < ActiveRecord::Migration[6.1]
  def change
    add_column :pages, :is_public, :boolean, default: false
  end
end
