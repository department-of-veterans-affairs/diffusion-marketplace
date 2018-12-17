class CreatePractices < ActiveRecord::Migration[5.2]
  def change
    create_table :practices do |t|
      t.string :name
      t.string :short_name
      t.text :description
      t.integer :position
      t.boolean :is_vha_field
      t.boolean :is_program_office
      t.string :vha_visn
      t.string :medical_center
      t.text :business_case_summary
      t.string :support_network_email
      t.string :va_pulse_link
      t.text :additional_notes

      t.timestamps
    end

    add_attachment :practices, :main_display_image
  end
end
