require 'rails_helper'

describe 'Practice Show Page Diffusion Map', type: :feature, js: true do
  before do
    @user = User.create!(email: 'spongebob.squarepants@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @practice = Practice.create!(name: 'The Best Innovation Ever!', user: @user, initiating_facility: 'Test Facility', initiating_facility_type: 'other', tagline: 'Test tagline')
    visn_1 = Visn.create!(name: 'VISN 1', number: 2)
    @fac_1 = VaFacility.create!(
      visn: visn_1,
      station_number: "402GA",
      official_station_name: "Caribou VA Clinic",
      common_name: "Caribou",
      latitude: "44.2802701",
      longitude: "-69.70413586",
      street_address_state: "ME",
      station_phone_number: "207-623-2123 x",
      fy17_parent_station_complexity_level: "1c-High Complexity"
    )
    @fac_2 = VaFacility.create!(
      visn: visn_1,
      station_number: "526GA",
      official_station_name: "White Plains VA Clinic",
      common_name: "White Plains",
      latitude: "41.03280396",
      longitude: "-73.76256942",
      street_address_state: "NY",
      station_phone_number: "207-623-2123 x",
      fy17_parent_station_complexity_level: "1c-High Complexity"
    )
    @fac_3 = VaFacility.create!(
      visn: visn_1,
      station_number: "526GB",
      official_station_name: "Yonkers VA Clinic",
      common_name: "Yonkers",
      latitude: "40.93287478",
      longitude: "-73.89691934",
      street_address_state: "NY",
      station_phone_number: "207-623-2123 x",
      fy17_parent_station_complexity_level: "1c-High Complexity"
    )
    @fac_4 = VaFacility.create!(
      visn: visn_1,
      station_number: "542",
      official_station_name: "Coatesville VA Medical Center",
      common_name: "Coatesville",
      latitude: "39.99732257",
      longitude: "-75.80470313",
      street_address_state: "PA",
      station_phone_number: "207-623-2123 x",
      fy17_parent_station_complexity_level: "1c-High Complexity"
    )
    @fac_5 = VaFacility.create!(
      visn: visn_1,
      station_number: "558GC",
      official_station_name: "Morehead City VA Clinic",
      common_name: "Morehead City",
      latitude: "34.73635963",
      longitude: "-76.79874362",
      street_address_state: "NC",
      station_phone_number: "207-623-2123 x",
      fy17_parent_station_complexity_level: "1c-High Complexity"
    )
    @fac_6 = VaFacility.create!(
      visn: visn_1,
      station_number: "501GB",
      official_station_name: "Farmington VA Clinic",
      common_name: "Farmington-New Mexico",
      latitude: "36.76236081",
      longitude: "-108.14840433",
      street_address_state: "NM",
      station_phone_number: "207-623-2123 x",
      fy17_parent_station_complexity_level: "1c-High Complexity"
    )

    @dh = DiffusionHistory.create!(practice: @practice, va_facility: @fac_1)
    @dh_1 = DiffusionHistory.create!(practice: @practice, va_facility: @fac_2)
    @dh_2 = DiffusionHistory.create!(practice: @practice, va_facility: @fac_3)
    @dh_3 = DiffusionHistory.create!(practice: @practice, va_facility: @fac_4)
    @dh_4 = DiffusionHistory.create!(practice: @practice, va_facility: @fac_5)
    @dh_5 = DiffusionHistory.create!(practice: @practice, va_facility: @fac_6)
    @dhs = DiffusionHistoryStatus.create!(diffusion_history: @dh, status: 'In progress')
    @dhs_1 = DiffusionHistoryStatus.create!(diffusion_history: @dh_1, status: 'Unsuccessful', unsuccessful_reasons: [0])
    @dhs_2 = DiffusionHistoryStatus.create!(diffusion_history: @dh_2, status: 'Unsuccessful', unsuccessful_reasons: [0])
    @dhs_3 = DiffusionHistoryStatus.create!(diffusion_history: @dh_3, status: 'Completed')
    @dhs_4 = DiffusionHistoryStatus.create!(diffusion_history: @dh_4, status: 'Completed')
    @dhs_5 = DiffusionHistoryStatus.create!(diffusion_history: @dh_5, status: 'Completed')
    ENV['GOOGLE_API_KEY'] = ENV['GOOGLE_TEST_API_KEY']

    login_as(@user, :scope => :user, :run_callbacks => false)
  end

  after do
    ENV['GOOGLE_API_KEY'] = nil
  end

  context 'when visiting a practice page with diffusion history' do
    it 'should show the map and allow for filtering' do
      # need to select by title since there are duplicate divs with the same width
      marker_div = 'div[style*="width: 31px"][title=""]'
      visit innovation_path(@practice)
      expect(page).to have_selector('.dm-practice-diffusion-map', visible: true)
      expect(page).to have_selector(marker_div, visible: true)

      # filters button
      expect(page).to be_accessible.within '#mapFilters'
      # all markers
      marker_count = find_all(:css, marker_div).count
      expect(marker_count).to eq(6)

      # Filter out "Complete" status
      complete_filter_checkbox = find(:css, 'label[for="status_successful"]')
      complete_filter_checkbox.click
      expect(page).to have_selector(marker_div, visible: true)
      marker_count = find_all(:css, marker_div).count
      expect(marker_count).to eq(3)

      # Filter out "In progress" status
      in_progress_filter_checkbox = find(:css, 'label[for="status_in-progress"]')
      in_progress_filter_checkbox.click
      expect(page).to have_selector(marker_div, visible: true)
      marker_count = find_all(:css, marker_div).count
      expect(marker_count).to eq(2)

      # Filter out "Unsuccessful" status
      unsuccessful_filter_checkbox = find(:css, 'label[for="status_unsuccessful"]')
      unsuccessful_filter_checkbox.click
      marker_count = find_all(:css, marker_div).count
      expect(marker_count).to eq(0)

      # Bring back "Complete"
      complete_filter_checkbox.click
      expect(page).to have_selector(marker_div, visible: true)
      marker_count = find_all(:css, marker_div).count
      expect(marker_count).to eq(3)
    end

    it 'should allow the user to visit each adoption\'s VA facility page' do
      DiffusionHistory.where.not(va_facility: @fac_6).destroy_all
      VaFacility.where.not(official_station_name: 'Farmington VA Clinic').destroy_all
      visit innovation_path(@practice)
      # click on the generated marker to open the modal
      find('div[style*="width: 31px"][title=""]').click
      # make sure the user is taken to the VA facility's show page that corresponds with that marker's diffusion history
      new_window = window_opened_by { click_link('Farmington VA Clinic (Farmington-New Mexico)') }
      within_window new_window do
        expect(page).to have_content('Farmington VA Clinic')
        expect(page).to have_content('This facility has created')
        expect(page).to have_content('Main number:')
      end
    end
  end
end
