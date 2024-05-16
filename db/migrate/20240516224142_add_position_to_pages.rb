class AddPositionToPages < ActiveRecord::Migration[6.1]
  def change
    add_column :pages, :position, :integer
  end
end
