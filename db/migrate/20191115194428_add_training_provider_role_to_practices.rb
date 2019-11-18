class AddTrainingProviderRoleToPractices < ActiveRecord::Migration[5.2]
  def change
    add_column :practices, :training_provider_role, :string
  end
end
