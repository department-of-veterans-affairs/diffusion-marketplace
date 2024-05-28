class AddShortNameToPages < ActiveRecord::Migration[6.1]
  def change
    add_column :pages, :short_name, :string
  end
end
