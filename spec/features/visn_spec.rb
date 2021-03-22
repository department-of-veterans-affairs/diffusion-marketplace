require 'rails_helper'

describe 'VISN pages', type: :feature do
  before do
    @visn = Visn.create!(
      name: 'Test VISN',
      number: 2,
      street_address: "100 Test Avenue",
      city: "Tampa",
      state: "FL",
      zip_code: "33728",
      latitude: "28.063901",
      longitude: "-82.466679",
      phone_number: "111-111-1111"
    )
    @visn_2 = Visn.create!(
      name: 'Test VISN',
      number: 5,
      street_address: "111 Test Street",
      city: "Dallas",
      state: "TX",
      zip_code: "75211",
      latitude: "32.880578",
      longitude: "-96.754906",
      phone_number: "111-000-0000"
    )
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
    @vamc_2 = Vamc.create!(
      visn: @visn_2,
      sta3n: 421,
      station_number: 421,
      official_station_name: 'Second test name',
      common_name: 'Second Test Common Name',
      classification: 'VA Medical Center (VAMC)',
      classification_status: 'Firm',
      mobile: 'Yes',
      parent_station_number: 454,
      official_parent_station_name: 'Second test station',
      fy17_parent_station_complexity_level: '1c-High Complexity',
      operational_status: 'A',
      ownership_type: 'VA Owned Asset',
      delivery_mechanism: nil,
      staffing_type: 'VA Staff Only',
      va_secretary_10n_approved_date: '-12324',
      planned_activation_date: '-12684',
      station_number_suffix_reservation_effective_date: '01/27/1991',
      operational_date: '-14321',
      date_of_first_workload: 'Pre-FY2000',
      points_of_service: 2,
      street_address: '1 Test St',
      street_address_city: 'Tampa',
      street_address_state: 'FL',
      street_address_zip_code: '11111',
      street_address_zip_code_extension: '1111',
      county_street_address: 'Test 2',
      mailing_address: '1 Test St',
      mailing_address_city: 'Tampa',
      mailing_address_state: 'FL',
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
      saturday: '-',
      sunday: '-',
      hours_note: 'This is a second test'
    )
  end

  def switch_browser_windows
    window = page.driver.browser.window_handles
    page.driver.browser.switch_to.window(window.last)
  end

  def expect_metadata(element)
    within(:css, element) do
      expect(find('.visn-vamc-count').text).to eq('1 facility')
      expect(find('.visn-practice-creations-count').text).to eq('0 practices created here')
      expect(find('.visn-adoptions-count').text).to eq('0 practices adopted here')
    end
  end

  describe 'index page' do
    before do
      visit '/visn'
    end

    it 'should be there' do
      visit '/visns'
      expect(page).to have_current_path(visns_path)
    end

    describe 'visn map' do
      before do
        @marker_div = 'div[style*="width: 48px"][title=""]'
        @markers = find_all(:css, @marker_div)
      end

      it 'should be there with the correct amount of markers' do
        expect(@markers.count).to eq(2)
      end

      it 'should show metadata for each visn' do
        @markers.last.click

        expect_metadata('#visn-5-marker-modal')
      end

      it 'should allow the user to visit a visn\'s show page via clicking on a visn link within a marker modal' do
        @markers.last.click
        click_link 'VISN 5'

        switch_browser_windows

        expect(page).to have_current_path(visn_path(@visn_2))
        expect(page).to have_content('5')
      end
    end

    describe 'visn cards' do
      before do
        @cards = find_all(:css, '.dm-visn-card')
      end

      it 'should show a card for every visn' do
        expect(@cards.count).to eq(2)
      end

      it 'should show metadata for each visn' do
        expect_metadata('#visn-2-card-link')
      end

      it 'should allow the user to visit a visn\'s show page via clicking on a visn card' do
        @cards.first.click

        switch_browser_windows

        expect(page).to have_content('2')
        expect(page).to have_current_path(visn_path(@visn))
      end
    end

  end

  describe 'show page' do
    it 'should be there if the VISN number exists in the DB' do
      visit '/visns/2'
      expect(page).to have_current_path(visn_path(@visn))
    end
  end
end