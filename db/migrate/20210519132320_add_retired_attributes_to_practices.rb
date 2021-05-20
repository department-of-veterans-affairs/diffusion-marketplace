class AddRetiredAttributesToPractices < ActiveRecord::Migration[5.2]
  def change
    add_column :practices, :retired, :boolean, null: false, default: false
    add_column :practices, :retired_reason, :string
  end
end