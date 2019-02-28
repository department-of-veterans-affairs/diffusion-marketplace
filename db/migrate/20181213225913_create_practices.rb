class CreatePractices < ActiveRecord::Migration[5.2]
  def change
    create_table :practices do |t|
      t.string :name
      t.string :short_name
      t.text :description
      t.integer :position
      t.string :cboc
      t.string :program_office
      t.string :initiating_facility
      t.string :vha_visn
      t.string :medical_center
      t.integer :number_adopted, default: 0
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

      t.string :tagline
      t.string :gold_status_tagline
      t.string :summary

      t.integer :risk_level_aggregate, default: 0
      t.integer :cost_savings_aggregate, default: 0
      t.integer :cost_to_implement_aggregate, default: 0
      t.integer :veteran_satisfaction_aggregate, default: 0
      t.integer :difficulty_aggregate, default: 0

      t.string :origin_title
      t.string :origin_story

      t.boolean :need_additional_staff
      t.boolean :need_training
      t.boolean :need_policy_change
      t.boolean :need_new_license

      t.string :training_provider
      t.text :required_training_summary

      t.string :facility_complexity_level

      t.timestamps
    end

    add_attachment :practices, :main_display_image
    add_attachment :practices, :origin_picture
  end
end
