class AddEnabledToPractices  < ActiveRecord::Migration[5.2]
  def change
    add_column :practices, :enabled, :boolean, null: false, default: true
  end
end