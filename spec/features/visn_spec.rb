require 'rails_helper'

describe 'VISN pages', type: :feature do
  before do
    ENV['GOOGLE_API_KEY'] = ENV['GOOGLE_TEST_API_KEY']
    @visn = Visn.create!(
      name: 'Test VISN',
      number: 1,
      street_address: "111 Test Street",
      city: "Dallas",
      state: "TX",
      zip_code: "75211",
      latitude: "32.880578",
      longitude: "-96.754906",
      phone_number: "111-000-0000"
    )
    @visn_2 = Visn.create!(
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

    @visn_liaison = VisnLiaison.create!(
      visn: @visn,
      first_name: 'Megumi',
      last_name: 'Fushiguro',
      email: 'megumi.fushiguro@va.gov',
      primary: true
    )

    @visn_liaison_2 = VisnLiaison.create!(
      visn: @visn_2,
      first_name: 'Toge',
      last_name: 'Inumaki',
      email: 'toge.inumaki@va.gov',
      primary: true
    )

    @va_facility = VaFacility.create!(
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
    @va_facility_2 = VaFacility.create!(
      visn: @visn_2,
      sta3n: 454,
      station_number: 424,
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
    @va_facility_3 = VaFacility.create!(
      visn: @visn_2,
      sta3n: 454,
      station_number: 443,
      official_station_name: 'Third test name',
      common_name: 'Third Test Common Name',
      classification: 'Primary Care CBOC',
      classification_status: 'Firm',
      mobile: 'Yes',
      parent_station_number: 454,
      official_parent_station_name: 'Third test station',
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
      street_address: '1 Test Ln',
      street_address_city: 'Clearwater',
      street_address_state: 'FL',
      street_address_zip_code: '11111',
      street_address_zip_code_extension: '1111',
      county_street_address: 'Test 2',
      mailing_address: '1 Test Ln',
      mailing_address_city: 'Clearwater',
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
      latitude: '27.96636756',
      longitude: '-82.79163245',
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
      hours_note: 'This is a third test'
    )
    @va_facility_4 = VaFacility.create!(
      visn: @visn_2,
      sta3n: 454,
      station_number: 431,
      official_station_name: 'Fourth test name',
      common_name: 'Fourth Test Common Name',
      classification: 'Residential Care Site (MH RRTP/DRRTP) (Stand-Alone)',
      classification_status: 'Firm',
      mobile: 'Yes',
      parent_station_number: 454,
      official_parent_station_name: 'Fourth test station',
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
      street_address: '1 Test Circle',
      street_address_city: 'Warner Robins',
      street_address_state: 'GA',
      street_address_zip_code: '22222',
      street_address_zip_code_extension: '2222',
      county_street_address: 'Test 2',
      mailing_address: '1 Test Circle',
      mailing_address_city: 'Warner Robins',
      mailing_address_state: 'GA',
      mailing_address_zip_code: '22222',
      mailing_address_zip_code_extension: '2222',
      county_mailing_address: 'Test',
      station_phone_number: '207-623-8411',
      station_main_fax_number: '207-623-8412',
      after_hours_phone_number: '207-623-7211',
      pharmacy_phone_number: '286-322-1342',
      enrollment_coordinator_phone_number: '207-623-9332',
      patient_advocate_phone_number: '207-623-1122',
      latitude: '32.60681842',
      longitude: '-83.64688667',
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
      hours_note: 'This is a fourth test'
    )

    @user = User.create!(email: 'nobara.kugisaki@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now)

    @practice = Practice.create!(name: 'The Best Practice Ever!', initiating_facility_type: 'facility', tagline: 'Test tagline', date_initiated: 'Sun, 05 Feb 1992 00:00:00 UTC +00:00', summary: 'This is the best practice ever.', overview_problem: 'overview-problem', published: true, enabled: true, approved: true, user: @user)
    PracticeOriginFacility.create!(practice: @practice, facility_type: 0, facility_id: '421')
    @practice_2 = Practice.create!(name: 'The Second Best Practice Ever!', initiating_facility_type: 'visn', initiating_facility: '2', tagline: 'Test tagline 2', date_initiated: 'Sun, 24 Oct 2004 00:00:00 UTC +00:00', summary: 'This is another best practice.', published: true, enabled: true, approved: true, user: @user)

    @dh = DiffusionHistory.create!(practice_id: @practice.id, facility_id: '443')
    @dh_2 = DiffusionHistory.create!(practice_id: @practice_2.id, facility_id: '431')
  end

  after do
    ENV['GOOGLE_API_KEY'] = nil
  end

  def expect_metadata(element, facility_count_text, practices_created_count_text, practices_adopted_count_text)
    within(:css, element) do
      expect(find('.visn-facility-count').text).to eq(facility_count_text)
      expect(find('.visn-practice-creations-count').text).to eq(practices_created_count_text)
      expect(find('.visn-adoptions-count').text).to eq(practices_adopted_count_text)
    end
  end

  describe 'index page' do
    before do
      visit '/visns'
    end

    it 'should be there' do
      expect(page).to have_current_path(visns_path)
    end

    describe 'visns index map' do
      before do
        @marker_div = 'div[style*="width: 48px"][title=""]'
        @markers = find_all(:css, @marker_div)
      end

      it 'should be there with the correct amount of markers' do
        expect(@markers.count).to eq(2)
      end

      it 'should show metadata for each visn' do
        @markers.last.click

        expect_metadata('#visn-2-marker-modal', '3 facilities', '1 practice created here', '2 practices adopted here')
      end

      it 'should have a link to a given visn\'s show page within that visn\'s marker modal' do
        @markers.last.click

        within(:css, '#visn-2-marker-modal') do
          expect(find('.visn-modal-link')[:href]).to include('/visns/2')
        end
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
        expect_metadata('#visn-1-card-link', '1 facility', '1 practice created here', '0 practices adopted here')
      end

      it 'should allow the user to visit a visn\'s show page via clicking on a visn card' do
        @cards.first.click

        expect(page).to have_content('1')
        expect(page).to have_current_path(visn_path(@visn))
      end
    end

  end

  describe 'show page' do
    it 'should be there if the VISN number exists in the DB' do
      visit '/visns/1'
      expect(page).to have_current_path(visn_path(@visn))
    end

    it 'should display a brief breakdown of the visn\'s metadata' do
      visit '/visns/2'

      expect(page).to have_content('This VISN has 3 facilities and serves Veterans in Florida and Georgia.')
      expect(page).to have_content('Collectively, its facilities have created 1 practice and have adopted 2 practices.')
    end

    describe 'visns show map' do
      before do
        @marker_div = 'div[style*="width: 48px"][title=""]'
        @markers = find_all(:css, @marker_div)
      end
    end
  end
end