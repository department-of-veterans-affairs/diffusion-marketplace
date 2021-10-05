class AddIsPublicToPractices < ActiveRecord::Migration[5.2]
  def change
    add_column :practices, :is_public, :boolean, default: false
  end
end
