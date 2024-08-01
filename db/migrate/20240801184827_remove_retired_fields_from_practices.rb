class RemoveRetiredFieldsFromPractices < ActiveRecord::Migration[6.1]
  def change
    remove_column :practices, :gold_status_tagline, :string
    remove_column :practices, :target_measures, :string
    remove_column :practices, :target_success, :integer
    remove_column :practices, :phase_gate, :string
  end
end
