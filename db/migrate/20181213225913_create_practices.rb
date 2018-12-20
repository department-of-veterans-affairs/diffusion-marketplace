class CreatePractices < ActiveRecord::Migration[5.2]
  def change
    create_table :practices do |t|
      t.string :name
      t.string :short_name
      t.text :description
      t.integer :position
      t.string :cboc
      t.string :program_office
      t.string :vha_visn
      t.string :medical_center
      t.text :business_case_summary
      t.string :support_network_email
      t.string :va_pulse_link
      t.text :additional_notes
      t.datetime :date_initiated

      t.text :impact_veteran_experience
      t.text :impact_veteran_satisfaction
      t.text :impact_other_veteran_experience

      t.text :impact_financial_estimate_saved
      t.text :impact_financial_per_veteran
      t.text :impact_financial_roi
      t.text :impact_financial_other

      t.string :phase_gate
      t.string :successful_implementation

      t.string :target_measures
      t.integer :target_success

      t.string :implementation_time_estimate

      t.timestamps
    end

    add_attachment :practices, :main_display_image
  end
end
