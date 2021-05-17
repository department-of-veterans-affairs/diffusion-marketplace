class CreateVamcs < ActiveRecord::Migration[5.2]
  def change
    create_table :vamcs do |t|
      t.belongs_to :visn, foreign_key: true
      t.string :sta3n
      t.string :station_number
      t.string :official_station_name
      t.string :common_name
      t.string :classification
      t.string :classification_status
      t.string :mobile
      t.string :parent_station_number
      t.string :official_parent_station_name
      t.string :fy17_parent_station_complexity_level
      t.string :operational_status
      t.string :ownership_type
      t.string :delivery_mechanism
      t.string :staffing_type
      t.string :va_secretary_10n_approved_date
      t.string :planned_activation_date
      t.date :station_number_suffix_reservation_effective_date
      t.string :operational_date
      t.string :date_of_first_workload
      t.string :points_of_service
      t.string :street_address
      t.string :street_address_city
      t.string :street_address_state
      t.string :street_address_zip_code
      t.string :street_address_zip_code_extension
      t.string :county_street_address
      t.string :mailing_address
      t.string :mailing_address_city
      t.string :mailing_address_state
      t.string :mailing_address_zip_code
      t.string :mailing_address_zip_code_extension
      t.string :county_mailing_address
      t.string :station_phone_number
      t.string :station_main_fax_number
      t.string :after_hours_phone_number
      t.string :pharmacy_phone_number
      t.string :enrollment_coordinator_phone_number
      t.string :patient_advocate_phone_number
      t.decimal :latitude, precision: 11, scale: 8
      t.decimal :longitude, precision: 11, scale: 8
      t.string :congressional_district
      t.string :market
      t.string :sub_market
      t.string :sector
      t.string :fips_code
      t.string :rurality
      t.string :monday
      t.string :tuesday
      t.string :wednesday
      t.string :thursday
      t.string :friday
      t.string :saturday
      t.string :sunday
      t.text :hours_note
      t.string :slug, unique: true

      t.timestamps
    end
  end
end