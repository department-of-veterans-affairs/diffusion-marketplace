require 'rails_helper'

describe 'Practice Show Page Diffusion Map', type: :feature, js: true do
  before do
    @user = User.create!(email: 'spongebob.squarepants@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @practice = Practice.create!(name: 'The Best Practice Ever!', user: @user, initiating_facility: 'Test Facility', initiating_facility_type: 'other', tagline: 'Test tagline')
    visn_1 = Visn.create!(name: 'VISN 1', number: 2)
    @fac_1 = VaFacility.create!(
      visn: visn_1,
      station_number: "402GA",
      official_station_name: "Caribou VA Clinic",
      common_name: "Caribou",
      latitude: "44.2802701",
      longitude: "-69.70413586",
      street_address_state: "ME"
    )
    @fac_2 = VaFacility.create!(
      visn: visn_1,
      station_number: "526GA",
      official_station_name: "White Plains VA Clinic",
      common_name: "White Plains",
      latitude: "41.03280396",
      longitude: "-73.76256942",
      street_address_state: "NY"
    )
    @fac_3 = VaFacility.create!(
      visn: visn_1,
      station_number: "526GB",
      official_station_name: "Yonkers VA Clinic",
      common_name: "Yonkers",
      latitude: "40.93287478",
      longitude: "-73.89691934",
      street_address_state: "NY"
    )
    @fac_4 = VaFacility.create!(
      visn: visn_1,
      station_number: "542",
      official_station_name: "Coatesville VA Medical Center",
      common_name: "Coatesville",
      latitude: "39.99732257",
      longitude: "-75.80470313",
      street_address_state: "PA"
    )
    @fac_5 = VaFacility.create!(
      visn: visn_1,
      station_number: "558GC",
      official_station_name: "Morehead City VA Clinic",
      common_name: "Morehead City",
      latitude: "34.73635963",
      longitude: "-76.79874362",
      street_address_state: "NC"
    )
    @fac_6 = VaFacility.create!(
      visn: visn_1,
      station_number: "501GB",
      official_station_name: "Farmington VA Clinic",
      common_name: "Farmington-New Mexico",
      latitude: "36.76236081",
      longitude: "-108.14840433",
      street_address_state: "NM"
    )

    @dh = DiffusionHistory.create!(practice: @practice, facility_id: @fac_1.station_number)
    @dh_1 = DiffusionHistory.create!(practice: @practice, facility_id: @fac_2.station_number)
    @dh_2 = DiffusionHistory.create!(practice: @practice, facility_id: @fac_3.station_number)
    @dh_3 = DiffusionHistory.create!(practice: @practice, facility_id: @fac_4.station_number)
    @dh_4 = DiffusionHistory.create!(practice: @practice, facility_id: @fac_5.station_number)
    @dh_5 = DiffusionHistory.create!(practice: @practice, facility_id: @fac_6.station_number)
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
      visit practice_path(@practice)
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
  end
end
