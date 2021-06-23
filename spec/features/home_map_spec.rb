require 'rails_helper'

describe 'Map of Diffusion', type: :feature, js: true do
  before do
    @user = User.create!(email: 'spongebob.squarepants@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @user_practice = Practice.create!(name: 'The Best Practice Ever!', user: @user, initiating_facility: 'Test Facility', initiating_facility_type: 'other', tagline: 'Test tagline')
    @pr_1 = Practice.create!(name: 'Practice A', approved: true, published: true, tagline: 'Practice A Tagline', date_initiated: Time.now(), user: @user)
    @pr_2 = Practice.create!(name: 'Practice B', approved: true, published: true, tagline: 'Practice B Tagline', date_initiated: Time.now(), user: @user)
    @pr_3 = Practice.create!(name: 'Practice C', approved: true, published: true, tagline: 'Practice C Tagline', date_initiated: Time.now(), user: @user)
    @pr_4 = Practice.create!(name: 'Practice D', approved: true, published: true, tagline: 'Practice D Tagline', date_initiated: Time.now(), user: @user)
    @visn_1 = Visn.create!(name: 'VISN 1', number: 2)
    @visn_2 = Visn.create!(name: 'VISN 2', number: 3)
    @fac_1 = VaFacility.create!(
      visn: @visn_1,
      station_number: "402GA",
      official_station_name: "Caribou VA Clinic",
      common_name: "Caribou",
      latitude: "44.2802701",
      longitude: "-69.70413586",
      street_address_state: "ME",
      rurality: "R",
      fy17_parent_station_complexity_level: '1c-High Complexity'
    )
    @fac_2 = VaFacility.create!(
      visn: @visn_2,
      station_number: "526GA",
      official_station_name: "White Plains VA Clinic",
      common_name: "White Plains",
      latitude: "41.03280396",
      longitude: "-73.76256942",
      street_address_state: "NY",
      rurality: "U",
      fy17_parent_station_complexity_level: '1b-High Complexity'
    )
    @fac_3 = VaFacility.create!(
      visn: @visn_2,
      station_number: "526GB",
      official_station_name: "Yonkers VA Clinic",
      common_name: "Yonkers",
      latitude: "40.93287478",
      longitude: "-73.89691934",
      street_address_state: "NY",
      rurality: "U",
      fy17_parent_station_complexity_level: '1a-High Complexity'
    )
    dh_1 = DiffusionHistory.create!(practice: @pr_1, facility_id: @fac_1.station_number)
    DiffusionHistoryStatus.create!(diffusion_history: dh_1, status: 'Completed')
    dh_2 = DiffusionHistory.create!(practice: @pr_1, facility_id: @fac_2.station_number)
    DiffusionHistoryStatus.create!(diffusion_history: dh_2, status: 'Implemented')
    dh_3 = DiffusionHistory.create!(practice: @pr_2, facility_id: @fac_1.station_number)
    DiffusionHistoryStatus.create!(diffusion_history: dh_3, status: 'Planning')
    dh_4 = DiffusionHistory.create!(practice: @pr_3, facility_id: @fac_1.station_number)
    DiffusionHistoryStatus.create!(diffusion_history: dh_4, status: 'In progress')
    dh_5 = DiffusionHistory.create!(practice: @pr_3, facility_id: @fac_2.station_number)
    DiffusionHistoryStatus.create!(diffusion_history: dh_5, status: 'Implementing')
    dh_6 = DiffusionHistory.create!(practice: @pr_4, facility_id: @fac_3.station_number)
    DiffusionHistoryStatus.create!(diffusion_history: dh_6, status: 'Unsuccessful', unsuccessful_reasons: [0])
    ENV['GOOGLE_API_KEY'] = ENV['GOOGLE_TEST_API_KEY']
    visit '/diffusion-map'
    expect(page).to have_selector(".diffusion-map-container", visible: true)
    expect(page).to have_selector("#filterResultsTrigger", visible: true)
  end

  after do
    ENV['GOOGLE_API_KEY'] = nil
  end

  def open_filters
    find("#filterResultsTrigger").click
  end

  def update_results
    find('.update-map-results-button').click
  end

  def reset_filters
    find("#allMarkersButton").click
  end

  def expect_marker_ct(count)
    marker_div = 'div[style*="width: 31px"][title=""]'
    expect(page).to have_selector(marker_div, visible: true)
    marker_count = find_all(:css, marker_div).count
    expect(marker_count).to be(count)
  end

  def click_first_map_marker
    find('#map > div:nth-child(1) > div:nth-child(1) > div:nth-child(2) > div:nth-child(3) > div:nth-child(1) > div:nth-child(3) > div:nth-child(1) > img', visible: true).click
  end

  it 'displays and filters the map' do
    expect_marker_ct(3)

    # filters button
    expect(page).to be_accessible.within '#filterResultsTrigger'
    expect(page).to have_css('#filterResultsTrigger')
    expect(page).to have_no_css('#filterClose')

    # filters on load
    open_filters
    expect(page).to have_no_css('modal-content')
    expect(page).to be_accessible.within '#filterResults'
    expect(page).to have_no_css('#filterResultsTrigger')
    expect(page).to have_css('#filterClose')
    expect(page).to have_content('3 facility matches (of 3)')
    expect(page).to have_content('4 practices matched (of 4)')

    # open facility complexity modal
    modal_text = 'Facilities with high volume, high risk patients, most complex clinical programs, and large research and teaching programs'
    expect(page).to_not have_content(modal_text)
    find('.fa-question-circle').click
    expect(page).to have_content(modal_text)
    find('.fa-times').click
    expect(page).to_not have_content(modal_text)

    # filters by practices
    find('.usa-checkbox__label[for="practice_ids_3"]').click
    find('.usa-checkbox__label[for="practice_ids_4"]').click
    update_results
    expect_marker_ct(2)
    expect(page).to have_content('2 facility matches (of 3)')
    expect(page).to have_content('3 practices matched (of 4)')
    reset_filters

    # filters by status
    # in-progress adoptions
    find('.adoption-status-label[for="status_in-progress"]').click
    update_results
    expect_marker_ct(2)
    expect(page).to have_content('2 facility matches (of 3)')
    expect(page).to have_content('3 practices matched (of 4)')
    # in-progress & unsuccessful adoptions
    find('.adoption-status-label[for="status_unsuccessful"]').click
    update_results
    expect_marker_ct(3)
    expect(page).to have_content('3 facility matches (of 3)')
    expect(page).to have_content('4 practices matched (of 4)')
    # successful adoptions
    find('.adoption-status-label[for="status_in-progress"]').click
    update_results
    expect_marker_ct(1)
    expect(page).to have_content('1 facility match (of 3)')
    expect(page).to have_content('1 practice matched (of 4)')
    reset_filters

    # filters by visn
    # @visn_1
    find('.usa-checkbox__label[for="VISN_1"]').click
    update_results
    expect_marker_ct(1)
    expect(page).to have_content('1 facility match (of 3)')
    expect(page).to have_content('3 practices matched (of 4)')
    # @visn_2
    find('.usa-checkbox__label[for="VISN_1"]').click
    find('.usa-checkbox__label[for="VISN_2"]').click
    update_results
    expect_marker_ct(2)
    expect(page).to have_content('2 facility matches (of 3)')
    expect(page).to have_content('3 practices matched (of 4)')
    reset_filters

    # filters by facility
    find('.usa-combo-box__input').click
    find('#facility_name--list--option-0').click
    update_results
    expect_marker_ct(1)
    expect(page).to have_content('1 facility match (of 3)')
    expect(page).to have_content('3 practices matched (of 4)')
    find('.usa-combo-box__clear-input').click
    update_results
    expect_marker_ct(3)
    expect(page).to have_content('3 facility matches (of 3)')
    expect(page).to have_content('4 practices matched (of 4)')
    reset_filters

    # filters by facilities
    expect(page).to have_css('#facilityListTrigger')
    expect(page).to have_content('View list of facilities')
    expect(page).to have_no_css('#facilityListContainer')
    find('#facilityListTrigger').click
    expect(page).to have_no_content('View list of facilities')
    expect(page).to have_content('Hide list of facilities')
    expect(page).to have_css('#facilityListContainer')
    find('.usa-checkbox__label[for="526GB"]').click
    update_results
    expect_marker_ct(1)
    expect(page).to have_content('1 facility match (of 3)')
    expect(page).to have_content('1 practice matched (of 4)')
    find('.usa-checkbox__label[for="526GA"]').click
    update_results
    expect_marker_ct(2)
    expect(page).to have_content('2 facility matches (of 3)')
    expect(page).to have_content('3 practices matched (of 4)')
    find('#facilityListTrigger').click
    expect(page).to have_content('View list of facilities')
    expect(page).to have_no_content('Hide list of facilities')
    expect(page).to have_no_css('#facilityListContainer')
    reset_filters

    # filters by complexity
    find('.usa-checkbox__label[for="1a_high_complexity"]').click
    update_results
    expect_marker_ct(1)
    expect(page).to have_content('1 facility match (of 3)')
    expect(page).to have_content('1 practice matched (of 4)')
    reset_filters

    # filters by rurality
    find('.usa-checkbox__label[for="rurality_U"]').click
    update_results
    expect_marker_ct(2)
    expect(page).to have_content('2 facility matches (of 3)')
    expect(page).to have_content('3 practices matched (of 4)')
    reset_filters

    #filters by multiple filters and resets
    find('.usa-checkbox__label[for="rurality_U"]').click
    find('.usa-checkbox__label[for="practice_ids_4"]').click
    update_results
    expect_marker_ct(1)
    expect(page).to have_content('1 facility match (of 3)')
    expect(page).to have_content('2 practices matched (of 4)')
    find('.adoption-status-label[for="status_unsuccessful"]').click
    update_results
    expect(page).to have_content('0 facility matches (of 3)')
    expect(page).to have_content('0 practices matched (of 4)')
    find("#allMarkersButton").click
    expect_marker_ct(3)
    expect(page).to have_content('3 facility matches (of 3)')
    expect(page).to have_content('4 practices matched (of 4)')

    # map modal
    click_first_map_marker
    expect(page).to have_content('Caribou VA Clinic')
    expect(page).to have_content('1 successful adoption')
    expect(page).to have_content('2 in-progress adoptions')
    expect(page).to have_content('0 unsuccessful adoptions')
    expect(page).to have_content('View more')
    click_button('View more')
    within(:css, '.modal-content') do
      expect(page).to have_content('Practice A')
      expect(page).to have_content('Practice B')
      expect(page).to have_content('Practice C')
    end
    find('.close').click
    expect(page).to have_no_css('.modal-content')
  end
end
