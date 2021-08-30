class AddHiddenToPractices < ActiveRecord::Migration[5.2]
  def change
    add_column :practices, :hidden, :boolean, null: false, default: false
  end
end
