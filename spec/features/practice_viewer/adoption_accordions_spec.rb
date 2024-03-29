require 'rails_helper'

describe 'Adoption accordions', type: :feature, js: true do
  before do
    ENV['GOOGLE_API_KEY'] = ENV['GOOGLE_TEST_API_KEY']
    @user = User.create!(email: 'renji.abarai@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @practice = Practice.create!(name: 'A public practice', approved: true, published: true, tagline: 'Test tagline', support_network_email: 'test@test.com', user: @user)
    visn_1 = Visn.create!(name: 'VISN 1', number: 1)
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
    dh_1 = DiffusionHistory.create!(practice: @practice, va_facility: @fac_1)
    DiffusionHistoryStatus.create!(diffusion_history: dh_1, status: 'Completed')
    dh_2 = DiffusionHistory.create!(practice: @practice, va_facility: @fac_2)
    DiffusionHistoryStatus.create!(diffusion_history: dh_2, status: 'In progress')
    dh_3 = DiffusionHistory.create!(practice: @practice, va_facility: @fac_3)
    DiffusionHistoryStatus.create!(diffusion_history: dh_3, status: 'Unsuccessful', unsuccessful_reasons: [0])
  end

  after do
    ENV['GOOGLE_API_KEY'] = nil
  end

  describe 'adoption status tooltip' do
    desktop_successful_text = 'Facilities that have met adoption goals and implemented the innovation.'
    desktop_in_progress_text = 'Facilities that have started but not completed adopting the innovation.'
    desktop_unsuccessful_text = 'Facilities that started but stopped working towards adoption.'
    mobile_successful_text = 'Successful: Facilities that have met adoption goals and implemented the innovation.'
    mobile_in_progress_text = 'In-progress: Facilities that have started but not completed adopting the innovation.'
    mobile_unsuccessful_text = 'Unsuccessful: Facilities that started but stopped working towards adoption.'

    def mobile_tooltip_expectation_flow(text, element_1, element_2)
      expect(page).to have_selector('.padding-2', text: text, visible: false)
      # display modal
      find(element_1).click
      expect(page).to have_selector('.padding-2', text: text, visible: true)
      # close modal
      find(element_2).click
      expect(page).to have_selector('.padding-2', text: text, visible: false)
    end

    context 'mobile' do
      before do
        page.driver.browser.manage.window.resize_to(340, 580)
      end
    end
  end
end