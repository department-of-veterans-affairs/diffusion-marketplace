class AddFieldsToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :origin, :string
    add_column :products, :usage, :string
    add_column :products, :price, :string
  end
end
