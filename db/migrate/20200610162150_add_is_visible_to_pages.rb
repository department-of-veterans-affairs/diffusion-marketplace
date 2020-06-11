class AddIsVisibleToPages  < ActiveRecord::Migration[5.2]
  def change
    add_column :pages, :is_visible, :boolean, null: false, default: true
  end
end