require 'rails_helper'

describe 'VA facility pages', type: :feature do

  before do
    @visn = Visn.create!(name: 'Test VISN', number: 2)
    @va_facility1 = VaFacility.create!(
        visn: @visn,
        sta3n: 421,
        station_number: 421,
        official_station_name: 'A Test name',
        common_name: 'A first facility Test Common Name',
        classification: 'VA Medical Center (VAMC)',
        classification_status: 'Firm',
        mobile: 'No',
        parent_station_number: 414,
        official_parent_station_name: 'Test station',
        fy17_parent_station_complexity_level: '1a-High Complexity',
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
        hours_note: 'This is a test',
        slug: 'a-first-facility-test-common-name'
    )
    @va_facility2 = VaFacility.create!(
        visn: @visn,
        sta3n: 422,
        station_number: 422,
        official_station_name: 'B Test name',
        common_name: 'B Test Common Name',
        classification: 'VA Medical Center (VAMC)',
        classification_status: 'Firm',
        mobile: 'No',
        parent_station_number: 414,
        official_parent_station_name: 'Test station',
        fy17_parent_station_complexity_level: '1b-High Complexity',
        )
    @va_facility3 = VaFacility.create!(
        visn: @visn,
        sta3n: 4223,
        station_number: 4223,
        official_station_name: 'C Test name',
        common_name: 'C Test Common Name',
        classification: 'VA Medical Center (VAMC)',
        classification_status: 'Firm',
        mobile: 'No',
        parent_station_number: 414,
        official_parent_station_name: 'Test station',
        fy17_parent_station_complexity_level: '1c-High Complexity',
        )
    @va_facility4 = VaFacility.create!(
        visn: @visn,
        sta3n: 4224,
        station_number: 4224,
        official_station_name: 'D Test name',
        common_name: 'D Test Common Name',
        classification: 'VA Medical Center (VAMC)',
        classification_status: 'Firm',
        mobile: 'No',
        parent_station_number: 414,
        official_parent_station_name: 'Test station',
        fy17_parent_station_complexity_level: '1c-High Complexity',
        )
    @va_facility5 = VaFacility.create!(
        visn: @visn,
        sta3n: 5,
        station_number: 5,
        official_station_name: 'E Test name',
        common_name: 'E Test Common Name',
        classification: 'VA Medical Center (VAMC)',
        classification_status: 'Firm',
        mobile: 'No',
        parent_station_number: 414,
        official_parent_station_name: 'Test station',
        fy17_parent_station_complexity_level: '1c-High Complexity',
        )
    @va_facility6 = VaFacility.create!(
        visn: @visn,
        sta3n: 6,
        station_number: 6,
        official_station_name: 'F Test name',
        common_name: 'F Test Common Name',
        classification: 'VA Medical Center (VAMC)',
        classification_status: 'Firm',
        mobile: 'No',
        parent_station_number: 414,
        official_parent_station_name: 'Test station',
        fy17_parent_station_complexity_level: '1c-High Complexity',
        )
    @va_facility7 = VaFacility.create!(
        visn: @visn,
        sta3n: 7,
        station_number: 7,
        official_station_name: 'G Test name',
        common_name: 'G Test Common Name',
        classification: 'VA Medical Center (VAMC)',
        classification_status: 'Firm',
        mobile: 'No',
        parent_station_number: 414,
        official_parent_station_name: 'Test station',
        fy17_parent_station_complexity_level: '1c-High Complexity',
        )
    @va_facility8 = VaFacility.create!(
        visn: @visn,
        sta3n: 8,
        station_number: 8,
        official_station_name: 'H Test name',
        common_name: 'H Test Common Name',
        classification: 'VA Medical Center (VAMC)',
        classification_status: 'Firm',
        mobile: 'No',
        parent_station_number: 414,
        official_parent_station_name: 'Test station',
        fy17_parent_station_complexity_level: '1c-High Complexity',
        )
    @va_facility9 = VaFacility.create!(
        visn: @visn,
        sta3n: 9,
        station_number: 9,
        official_station_name: 'I Test name',
        common_name: 'I Test Common Name',
        classification: 'VA Medical Center (VAMC)',
        classification_status: 'Firm',
        mobile: 'No',
        parent_station_number: 414,
        official_parent_station_name: 'Test station',
        fy17_parent_station_complexity_level: '1c-High Complexity',
        )
    @va_facility10 = VaFacility.create!(
        visn: @visn,
        sta3n: 10,
        station_number: 10,
        official_station_name: 'J Test name',
        common_name: 'J Test Common Name',
        classification: 'VA Medical Center (VAMC)',
        classification_status: 'Firm',
        mobile: 'No',
        parent_station_number: 414,
        official_parent_station_name: 'Test station',
        fy17_parent_station_complexity_level: '1c-High Complexity',
        )
    @va_facility11 = VaFacility.create!(
        visn: @visn,
        sta3n: 11,
        station_number: 11,
        official_station_name: 'K Test name',
        common_name: 'K Test Common Name',
        classification: 'VA Medical Center (VAMC)',
        classification_status: 'Firm',
        mobile: 'No',
        parent_station_number: 414,
        official_parent_station_name: 'Test station',
        fy17_parent_station_complexity_level: '1c-High Complexity',
        )
    @va_facility12 = VaFacility.create!(
        visn: @visn,
        sta3n: 12,
        station_number: 12,
        official_station_name: 'L Test name',
        common_name: 'L Test Common Name',
        classification: 'VA Medical Center (VAMC)',
        classification_status: 'Firm',
        mobile: 'No',
        parent_station_number: 414,
        official_parent_station_name: 'Test station',
        fy17_parent_station_complexity_level: '1c-High Complexity',
        )
    @va_facility13 = VaFacility.create!(
        visn: @visn,
        sta3n: 13,
        station_number: 13,
        official_station_name: 'M Test name',
        common_name: 'M Test Common Name',
        classification: 'VA Medical Center (VAMC)',
        classification_status: 'Firm',
        mobile: 'No',
        parent_station_number: 414,
        official_parent_station_name: 'Test station',
        fy17_parent_station_complexity_level: '1c-High Complexity',
        )
    @va_facility14 = VaFacility.create!(
        visn: @visn,
        sta3n: 14,
        station_number: 14,
        official_station_name: 'N Test name',
        common_name: 'N Test Common Name',
        classification: 'VA Medical Center (VAMC)',
        classification_status: 'Firm',
        mobile: 'No',
        parent_station_number: 414,
        official_parent_station_name: 'Test station',
        fy17_parent_station_complexity_level: '1c-High Complexity',
        )
    @va_facility15 = VaFacility.create!(
        visn: @visn,
        sta3n: 15,
        station_number: 15,
        official_station_name: 'O Test name',
        common_name: 'O Test Common Name',
        classification: 'VA Medical Center (VAMC)',
        classification_status: 'Firm',
        mobile: 'No',
        parent_station_number: 414,
        official_parent_station_name: 'Test station',
        fy17_parent_station_complexity_level: '1c-High Complexity',
        )
    @va_facility16 = VaFacility.create!(
        visn: @visn,
        sta3n: 16,
        station_number: 16,
        official_station_name: 'P Test name',
        common_name: 'P Test Common Name',
        classification: 'VA Medical Center (VAMC)',
        classification_status: 'Firm',
        mobile: 'No',
        parent_station_number: 414,
        official_parent_station_name: 'Test station',
        fy17_parent_station_complexity_level: '1c-High Complexity',
        )
    @va_facility17 = VaFacility.create!(
        visn: @visn,
        sta3n: 17,
        station_number: 17,
        official_station_name: 'Q Test name',
        common_name: 'Q Test Common Name',
        classification: 'VA Medical Center (VAMC)',
        classification_status: 'Firm',
        mobile: 'No',
        parent_station_number: 414,
        official_parent_station_name: 'Test station',
        fy17_parent_station_complexity_level: '1c-High Complexity',
        )
    @va_facility18 = VaFacility.create!(
        visn: @visn,
        sta3n: 18,
        station_number: 18,
        official_station_name: 'R Test name',
        common_name: 'R Test Common Name',
        classification: 'VA Medical Center (VAMC)',
        classification_status: 'Firm',
        mobile: 'No',
        parent_station_number: 414,
        official_parent_station_name: 'Test station',
        fy17_parent_station_complexity_level: '1c-High Complexity',
        )
    @va_facility19 = VaFacility.create!(
        visn: @visn,
        sta3n: 19,
        station_number: 19,
        official_station_name: 'S Test name',
        common_name: 'S Test Common Name',
        classification: 'VA Medical Center (VAMC)',
        classification_status: 'Firm',
        mobile: 'No',
        parent_station_number: 414,
        official_parent_station_name: 'Test station',
        fy17_parent_station_complexity_level: '1c-High Complexity',
        )
    @va_facility20 = VaFacility.create!(
        visn: @visn,
        sta3n: 20,
        station_number: 20,
        official_station_name: 'T Test name',
        common_name: 'T Test Common Name',
        classification: 'VA Medical Center (VAMC)',
        classification_status: 'Firm',
        mobile: 'No',
        parent_station_number: 414,
        official_parent_station_name: 'Test station',
        fy17_parent_station_complexity_level: '1c-High Complexity',
        )
    @va_facility21 = VaFacility.create!(
        visn: @visn,
        sta3n: 21,
        station_number: 21,
        official_station_name: 'U Test name',
        common_name: 'U last facility Common Name',
        classification: 'VA Medical Center (VAMC)',
        classification_status: 'Firm',
        mobile: 'No',
        parent_station_number: 414,
        official_parent_station_name: 'Test station',
        fy17_parent_station_complexity_level: '1c-High Complexity',
        slug: 'u-last-facility-common-name'
        )
  end

  describe 'index page' do
    it 'should be there' do
      visit '/facilities'
      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_current_path(va_facilities_path)
      expect(page).to have_content("Facility directory")
      expect(page).to have_content("Looking for a full list of VISNs?")
      expect(page).to have_content("Facilities")
      expect(page).to have_content("VISN")
      expect(page).to have_content("Type")
      expect(page).to have_content("first facility")
      expect(page).to have_content('last facility')
      expect(find_all('.usa-select').first.value).to eq ''
    end
  end

  describe 'index page complexity filter' do
    it 'should filter by complexity type' do
      visit '/facilities'
      select "1a-High Complexity", :from => "facility_type_select"
      section = find(:css, '#directory_table')
      expect(section).to have_content('1A')
      expect(section).to have_no_content('1B')
      expect(section).to have_no_content('1C')

      select "1b-High Complexity", :from => "facility_type_select"
      expect(section).to have_content('1B')
      expect(section).to have_no_content('1A')
      expect(section).to have_no_content('1C')

      select "1c-High Complexity", :from => "facility_type_select"
      expect(section).to have_content('1C')
      expect(section).to have_no_content('1A')
      expect(section).to have_no_content('1B')
    end
  end

  describe 'show page' do
    it 'should be there if the VA facility common name (friendly id) or id exists in the DB' do
      # visit using the friendly id
      visit '/facilities/a-first-facility-test-common-name'
      expect(page).to have_current_path(va_facility_path(@va_facility1))
      expect(page).to have_content("This facility has created 0 practices and has adopted 0 practices.")
      expect(page).to have_content("Practices adopted at this facility")
    end
  end

  describe 'Sorting' do
    it 'should sort the results in asc and desc order' do
      visit '/facilities'
      section = find(:css, '#directory_table') #the :css may be optional depending on your Capybara.default_selector setting
      expect(page).to have_content(@va_facility1.common_name)
      expect(page).to have_content("Load more")
      expect(section).to have_no_content("last facility")
      expect(section).to have_content('first facility')
      toggle_by_column('facility')
      expect(section).to have_content("last facility")
      expect(section).to have_no_content('first facility')
      find('#btn_facility_directory_load_more').click
      expect(section).to have_content("last facility")
      expect(section).to have_content('first facility')
    end
  end

  def toggle_by_column(column_name)
    find('#toggle_by_' + column_name).click
  end
end