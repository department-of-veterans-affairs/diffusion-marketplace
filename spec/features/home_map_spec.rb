require 'rails_helper'

describe 'Map of Diffusion', type: :feature do
  before do
    @user = User.create!(email: 'spongebob.squarepants@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin = User.create!(email: 'sandy.cheeks@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(User::USER_ROLES[1].to_sym)
    @user_practice = Practice.create!(name: 'The Best Practice Ever!', user: @user, initiating_facility: 'Test Facility', initiating_facility_type: 'other', tagline: 'Test tagline')
    @pr_1 = Practice.create!(name: 'Practice A', enabled: true, approved: true, summary: 'Test summary', published: true, tagline: 'Practice A Tagline', date_initiated: Time.now(), user: @user)
    @pr_2 = Practice.create!(name: 'Practice B', enabled: true, approved: true, summary: 'Test summary', published: true, tagline: 'Practice B Tagline', date_initiated: Time.now(), user: @user)
    @pr_3 = Practice.create!(name: 'Practice C', enabled: true, approved: true, summary: 'Test summary', published: true, tagline: 'Practice C Tagline', date_initiated: Time.now(), user: @user)
    @pr_4 = Practice.create!(name: 'Practice D', enabled: true, approved: true, summary: 'Test summary', published: true, tagline: 'Practice D Tagline', date_initiated: Time.now(), user: @user)
    @pr_5 = Practice.create!(name: 'Practice E', enabled: true, approved: true, summary: 'Test summary', published: true, tagline: 'Practice E Tagline', date_initiated: Time.now(), user: @user)
    @visn_1 = Visn.create!(name: 'VISN 1', number: 1)
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
      fy17_parent_station_complexity_level: "1c-High Complexity",
      station_phone_number: "207-623-2123 x"
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
      fy17_parent_station_complexity_level: "1b-High Complexity",
      station_phone_number: "207-623-2123 x"
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
      fy17_parent_station_complexity_level: "1a-High Complexity",
      station_phone_number: "207-623-2123 x"
    )
    @crh = ClinicalResourceHub.create!(
      visn: @visn_2,
      official_station_name: "VISN 2 Clinical Resource Hub",
    )
    dh_1 = DiffusionHistory.create!(practice: @pr_1, va_facility: @fac_1)
    DiffusionHistoryStatus.create!(diffusion_history: dh_1, status: 'Completed')
    dh_2 = DiffusionHistory.create!(practice: @pr_1, va_facility: @fac_2)
    DiffusionHistoryStatus.create!(diffusion_history: dh_2, status: 'Implemented')
    dh_3 = DiffusionHistory.create!(practice: @pr_2, va_facility: @fac_1)
    DiffusionHistoryStatus.create!(diffusion_history: dh_3, status: 'Planning')
    dh_4 = DiffusionHistory.create!(practice: @pr_3, va_facility: @fac_1)
    DiffusionHistoryStatus.create!(diffusion_history: dh_4, status: 'In progress')
    dh_5 = DiffusionHistory.create!(practice: @pr_3, va_facility: @fac_2)
    DiffusionHistoryStatus.create!(diffusion_history: dh_5, status: 'Implementing')
    dh_6 = DiffusionHistory.create!(practice: @pr_4, va_facility: @fac_3)
    DiffusionHistoryStatus.create!(diffusion_history: dh_6, status: 'Unsuccessful', unsuccessful_reasons: [0])
    ENV['GOOGLE_API_KEY'] = ENV['GOOGLE_TEST_API_KEY']
    login_as(@user, :scope => :user, :run_callbacks => false)
    visit '/diffusion-map'
    expect(page).to have_selector(".diffusion-map-container", visible: true)
    expect(page).to have_selector(".map-filters-accordion", visible: true)
  end

  after do
    ENV['GOOGLE_API_KEY'] = nil
  end

  def open_filters
    find(".map-filters-accordion-button").click
  end

  def update_results
    find('.update-map-results-button').click
  end

  def reset_filters
    find("#allMarkersButton").click
  end

  def expect_marker_ct(count)
    marker_div = 'div[style*="width: 31px"][role="button"]'
    expect(page).to have_selector(marker_div, visible: true)
    marker_count = find_all(:css, marker_div).count
    expect(marker_count).to be(count)
  end

  it 'displays and filters the map' do
    expect(page).to have_content('Explore how innovations are being adopted across the country. There are currently 2 successful adoptions, 3 in-progress adoptions, and 1 unsuccessful adoption.')
    expect_marker_ct(3)

    # make sure that CRH adoptions are included in the total count, but NOT display on the diffusion map
    dh_7 = DiffusionHistory.create!(practice: @pr_5, clinical_resource_hub: @crh)
    DiffusionHistoryStatus.create!(diffusion_history: dh_7, status: 'Unsuccessful', unsuccessful_reasons: [0])

    visit '/diffusion-map'
    expect(page).to have_content('Explore how innovations are being adopted across the country. There are currently 2 successful adoptions, 3 in-progress adoptions, and 2 unsuccessful adoptions.')
    expect_marker_ct(3)

    # filters button
    expect(page).to be_accessible.within '.map-filters-accordion'
    expect(page).to have_css('.map-filters-accordion')

    # filters on load
    open_filters
    expect(page).to have_selector('.modal-content', count: 3, visible: false)
    expect(page).to be_accessible.within '#filterResults'
    expect(page).to have_no_css('#filterResultsTrigger')
    expect(page).to have_selector('#mapFilters', visible: true)
    expect(page).to have_content('3 facility matches (of 3)')
    expect(page).to have_content('4 innovations matched (of 4)')
    # open facility complexity modal
    modal_text = 'Facilities with high volume, high risk patients, most complex clinical programs, and large research and teaching programs'
    expect(page).to_not have_content(modal_text)
    find_all('.facility-complexity-modal').last.click
    expect(page).to have_content(modal_text)
    find('.fa-times').click
    expect(page).to_not have_content(modal_text)

    # filters by practices
    find('.usa-checkbox__label[for="practice_ids_3"]').click
    find('.usa-checkbox__label[for="practice_ids_4"]').click
    update_results
    # make sure the accordion closes
    expect(page).to have_selector('#mapFilters', visible: false)
    expect_marker_ct(2)
    expect(page).to have_content('2 facility matches (of 3)')
    expect(page).to have_content('3 innovations matched (of 4)')
    open_filters
    reset_filters

    # filters by status
    # in-progress adoptions
    open_filters
    find('.adoption-status-label[for="status_in-progress"]').click
    update_results
    expect_marker_ct(2)
    expect(page).to have_content('2 facility matches (of 3)')
    expect(page).to have_content('3 innovations matched (of 4)')
    # in-progress & unsuccessful adoptions
    open_filters
    find('.adoption-status-label[for="status_unsuccessful"]').click
    update_results
    expect_marker_ct(3)
    expect(page).to have_content('3 facility matches (of 3)')
    expect(page).to have_content('4 innovations matched (of 4)')
    # successful adoptions
    open_filters
    find('.adoption-status-label[for="status_in-progress"]').click
    update_results
    expect_marker_ct(1)
    expect(page).to have_content('1 facility match (of 3)')
    expect(page).to have_content('1 innovation matched (of 4)')
    open_filters
    reset_filters

    # filters by visn
    # @visn_1
    open_filters
    find('.usa-checkbox__label[for="VISN_1"]').click
    update_results
    expect_marker_ct(1)
    expect(page).to have_content('1 facility match (of 3)')
    expect(page).to have_content('3 innovations matched (of 4)')
    # @visn_2
    open_filters
    find('.usa-checkbox__label[for="VISN_1"]').click
    find('.usa-checkbox__label[for="VISN_2"]').click
    update_results
    expect_marker_ct(2)
    expect(page).to have_content('2 facility matches (of 3)')
    expect(page).to have_content('3 innovations matched (of 4)')
    open_filters
    reset_filters

    # filters by facility
    open_filters
    find('.usa-combo-box__input').click
    find('#facility_name--list--option-0').click
    update_results
    expect_marker_ct(1)
    expect(page).to have_content('1 facility match (of 3)')
    expect(page).to have_content('3 innovations matched (of 4)')
    open_filters
    find('.usa-combo-box__clear-input').click
    update_results
    expect_marker_ct(3)
    expect(page).to have_content('3 facility matches (of 3)')
    expect(page).to have_content('4 innovations matched (of 4)')
    open_filters
    reset_filters

    # filters by facilities
    open_filters
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
    expect(page).to have_content('1 innovation matched (of 4)')
    open_filters
    find('.usa-checkbox__label[for="526GA"]').click
    update_results
    expect_marker_ct(2)
    expect(page).to have_content('2 facility matches (of 3)')
    expect(page).to have_content('3 innovations matched (of 4)')
    open_filters
    find('#facilityListTrigger').click
    expect(page).to have_content('View list of facilities')
    expect(page).to have_no_content('Hide list of facilities')
    expect(page).to have_no_css('#facilityListContainer')
    reset_filters

    # filters by complexity
    open_filters
    find('.usa-checkbox__label[for="1a_high_complexity"]').click
    update_results
    expect_marker_ct(1)
    expect(page).to have_content('1 facility match (of 3)')
    expect(page).to have_content('1 innovation matched (of 4)')
    open_filters
    reset_filters

    # filters by rurality
    open_filters
    find('.usa-checkbox__label[for="rurality_U"]').click
    update_results
    expect_marker_ct(2)
    expect(page).to have_content('2 facility matches (of 3)')
    expect(page).to have_content('3 innovations matched (of 4)')
    open_filters
    reset_filters

    #filters by multiple filters and resets
    open_filters
    find('.usa-checkbox__label[for="rurality_U"]').click
    find('.usa-checkbox__label[for="practice_ids_4"]').click
    update_results
    expect_marker_ct(1)
    expect(page).to have_content('1 facility match (of 3)')
    expect(page).to have_content('2 innovations matched (of 4)')
    open_filters
    find('.adoption-status-label[for="status_unsuccessful"]').click
    update_results
    expect(page).to have_content('0 facility matches (of 3)')
    expect(page).to have_content('0 innovations matched (of 4)')
    open_filters
    find("#allMarkersButton").click
    expect_marker_ct(3)
    expect(page).to have_content('3 facility matches (of 3)')
    expect(page).to have_content('4 innovations matched (of 4)')

    # map modal
    find('div[style*="width: 31px"][title="Caribou VA Clinic, 3 total adoptions"]').click
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
    expect(page).to have_selector('.modal-content', count: 3, visible: false)

    # make sure modals close when updating/resetting filters
    open_filters
    find('div[style*="width: 31px"][title="Caribou VA Clinic, 3 total adoptions"]').click
    expect(page).to have_content('View more')
    reset_filters
    expect(page).to_not have_content('View more')
    find('div[style*="width: 31px"][title="Caribou VA Clinic, 3 total adoptions"]').click
    click_button('View more')
    expect(page).to have_selector('.usa-link[href="/facilities/caribou"', visible: true)
    open_filters
    update_results
    expect(page).to have_selector('.usa-link[href="/facilities/caribou"', visible: false)
  end

  it 'should allow the user to visit each adoption\'s VA facility page', js: true do
    # click on the first generated marker
    find('div[style*="width: 31px"][title="Caribou VA Clinic, 3 total adoptions"]').click
    # in the marker modal, make sure the user is taken to the VA facility's show page that corresponds with that marker's diffusion history
    click_link('Caribou VA Clinic')
      expect(page).to have_content('Caribou VA Clinic')
      expect(page).to have_content('This facility has created')
      expect(page).to have_content('Main number:')
  end

  it 'should only display markers for facilities that have adoptions for public-facing practices if the user is a guest' do
    # view the map markers as a guest user
    logout
    visit '/diffusion-map'
    expect(page).to_not have_selector('div[style*="width: 31px"][role="button"]', visible: true)
    expect(page).to have_content('There are currently 0 successful adoptions, 0 in-progress adoptions, and 0 unsuccessful adoptions.')

    # login as an admin and set the 'is_public' flag for a practice to true
    login_as(@admin, :scope => :user, :run_callbacks => false)
    visit '/admin/practices'
    all('.toggle-practice-privacy-link')[4].click
    expect(page).to have_content("\"Practice A\" is now a public-facing innovation")

    # logout and view the map markers again as a guest user
    logout
    visit '/diffusion-map'

    expect(page).to have_content('Explore how innovations are being adopted across the country. There are currently 2 successful adoptions, 0 in-progress adoptions, and 0 unsuccessful adoptions.')
    expect_marker_ct(2)
  end
end
