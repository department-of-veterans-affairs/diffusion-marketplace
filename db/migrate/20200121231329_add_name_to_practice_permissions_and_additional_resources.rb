class AddNameToPracticePermissionsAndAdditionalResources < ActiveRecord::Migration[5.2]
  def change
    add_column :practice_permissions, :name, :string
    add_column :additional_resources, :name, :string
  end
end
