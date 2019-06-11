class AddFeaturedToPractices < ActiveRecord::Migration[5.2]
  def change
    add_column :practices, :highlight, :boolean, null: false, default: false
    add_column :practices, :featured, :boolean, null: false, default: false
  end
end
