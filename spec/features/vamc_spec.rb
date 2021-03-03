require 'rails_helper'

describe 'VAMC pages', type: :feature do

  before do
    @visn = Visn.create!(name: 'Test VISN', number: 2)
    @vamc = Vamc.create!(
          visn: @visn,
          sta3n: 421,
          station_number: 421,
          official_station_name: 'Test name',
          common_name: 'Test Common Name',
          classification: 'VA Medical Center (VAMC)',
          classification_status: 'Firm',
          mobile: 'No',
          parent_station_number: 414,
          official_parent_station_name: 'Test station',
          fy17_parent_station_complexity_level: '1c-High Complexity',
          operational_status: 'A',
          ownership_type: 'VA Owned Asset',
          delivery_mechanism: nil,
          staffing_type: 'VA Staff Only',
          va_secretary_10n_approved_date: '-12324',
          planned_activation_date: '-12684',
          station_number_suffix_reservation_effective_date: '05/23/1995',
          operational_date: '-14321',
          date_of_first_workload: 'Pre-FY2000',
          points_of_service: 2,
          street_address: '1 Test Ave',
          street_address_city: 'Las Vegas',
          street_address_state: 'NV',
          street_address_zip_code: '11111',
          street_address_zip_code_extension: '1111',
          county_street_address: 'Test',
          mailing_address: '1 Test Ave',
          mailing_address_city: 'Las Vegas',
          mailing_address_state: 'NV',
          mailing_address_zip_code: '11111',
          mailing_address_zip_code_extension: '1111',
          county_mailing_address: 'Test',
          station_phone_number: '207-623-8411',
          station_main_fax_number: '207-623-8412',
          after_hours_phone_number: '207-623-7211',
          pharmacy_phone_number: '286-322-1342',
          enrollment_coordinator_phone_number: '207-623-9332',
          patient_advocate_phone_number: '207-623-1122',
          latitude: '44.03409934',
          longitude: '-70.70545322',
          congressional_district: 'CD116_ME_23001',
          market: '01-b',
          sub_market: '01-b-9',
          sector: '01-b-10-A',
          fips_code: '23022',
          rurality: 'U',
          monday: '24/7',
          tuesday: '24/7',
          wednesday: '24/7',
          thursday: '24/7',
          friday: '24/7',
          saturday: '24/7',
          sunday: '24/7',
          hours_note: 'This is a test'
      )
  end

  describe 'index page' do
    it 'should be there' do
      visit '/vamc'
      expect(page).to have_current_path(vamcs_path)
    end
  end

  describe 'show page' do
    it 'should be there if the VAMC common name (friendly id) or id exists in the DB' do
      # visit using the friendly id
      visit '/vamc/test-common-name'
      expect(page).to_not have_current_path(visn_path(@vamc))

      # visit using the id
      visit '/vamc/1'
      expect(page).to_not have_current_path(visn_path(@vamc))
    end
  end
end