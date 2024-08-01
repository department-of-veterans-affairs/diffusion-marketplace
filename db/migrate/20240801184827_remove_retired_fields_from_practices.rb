class RemoveRetiredFieldsFromPractices < ActiveRecord::Migration[6.1]
  def change
    remove_column :practices, :gold_status_tagline, :string
    remove_column :practices, :target_measures, :string
    remove_column :practices, :target_success, :integer
    remove_column :practices, :phase_gate, :string
    remove_column :practices, :va_pulse_link, :string
    remove_column :practices, :business_case_summary, :text
    remove_column :practices, :additional_notes, :text
    remove_column :practices, :impact_veteran_experience, :text
    remove_column :practices, :impact_veteran_satisfaction, :text
    remove_column :practices, :impact_other_veteran_experience, :text
    remove_column :practices, :impact_financial_estimate_saved, :text
    remove_column :practices, :impact_financial_per_veteran, :text
    remove_column :practices, :impact_financial_roi, :text
    remove_column :practices, :impact_financial_other, :text
    remove_column :practices, :successful_implementation, :string
  end
end