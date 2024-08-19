class RemoveMoreFieldsFromPractices < ActiveRecord::Migration[6.1]
  def change
    remove_column :practices, :need_additional_staff, :boolean
    remove_column :practices, :need_training, :boolean
    remove_column :practices, :need_policy_change, :boolean
    remove_column :practices, :need_new_license, :boolean
    remove_column :practices, :training_provider, :string
    remove_column :practices, :training_provider_role, :string
    remove_column :practices, :training_test, :boolean
    remove_column :practices, :training_test_details, :boolean
    remove_column :practices, :required_training_summary, :text
    remove_column :practices, :training_length, :string
  end
end
