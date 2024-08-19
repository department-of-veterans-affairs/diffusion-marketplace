class RemoveMoreFieldsFromPractices < ActiveRecord::Migration[6.1]
  def change
    remove_column :practices, :need_additional_staff, :boolean
    remove_column :practices, :need_training, :boolean
    remove_column :practices, :need_policy_change, :boolean
    remove_column :practices, :need_new_license, :boolean
  end
end
