require 'rails_helper'

describe 'Adoption accordions', type: :feature, js: true do
  before do
    ENV['GOOGLE_API_KEY'] = ENV['GOOGLE_TEST_API_KEY']
    @user = User.create!(email: 'renji.abarai@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @practice = Practice.create!(name: 'A public practice', approved: true, published: true, tagline: 'Test tagline', support_network_email: 'test@test.com', user: @user)
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
    desktop_successful_text = 'Facilities that have met adoption goals and implemented the practice.'
    desktop_in_progress_text = 'Facilities that have started but not completed adopting the practice.'
    desktop_unsuccessful_text = 'Facilities that started but stopped working towards adoption.'
    mobile_successful_text = 'Successful: Facilities that have met adoption goals and implemented the practice.'
    mobile_in_progress_text = 'In-progress: Facilities that have started but not completed adopting the practice.'
    mobile_unsuccessful_text = 'Unsuccessful: Facilities that started but stopped working towards adoption.'

    def desktop_tooltip_expectation_flow(text, index)
      expect(page).to have_selector('.usa-tooltip__body', text: text, visible: false)
      all('.usa-tooltip')[index].hover
      expect(page).to have_selector('.usa-tooltip__body', text: text, visible: true)
    end

    def mobile_tooltip_expectation_flow(text, element_1, element_2)
      expect(page).to have_selector('.padding-2', text: text, visible: false)
      # display modal
      find(element_1).click
      expect(page).to have_selector('.padding-2', text: text, visible: true)
      # close modal
      find(element_2).click
      expect(page).to have_selector('.padding-2', text: text, visible: false)
    end

    context 'desktop' do
      it 'should display a tooltip with a definition of the adoption status for each status accordion' do
        login_as(@user, :scope => :user, :run_callbacks => false)
        visit innovation_path(@practice)
        expect(page).to have_content(@practice.name)

        # make sure the tooltip is shown for each status accordion
        desktop_tooltip_expectation_flow(desktop_successful_text, 0 )
        desktop_tooltip_expectation_flow(desktop_in_progress_text, 1)
        desktop_tooltip_expectation_flow(desktop_unsuccessful_text, 2)
      end
    end

    context 'mobile' do
      before do
        page.driver.browser.manage.window.resize_to(340, 580)
      end

      it 'should display a modal with a definition of the adoption status for each status accordion' do
        login_as(@user, :scope => :user, :run_callbacks => false)
        visit innovation_path(@practice)
        expect(page).to have_content(@practice.name)

        # make sure the modal appears for each status accordion
        mobile_tooltip_expectation_flow(mobile_successful_text, '.successful-modal-icon', '#close_successful_status_modal')
        mobile_tooltip_expectation_flow(mobile_in_progress_text, '.in-progress-modal-icon', '#close_in-progress_status_modal')
        mobile_tooltip_expectation_flow(mobile_unsuccessful_text, '.unsuccessful-modal-icon', '#close_unsuccessful_status_modal')
      end
    end
  end
end