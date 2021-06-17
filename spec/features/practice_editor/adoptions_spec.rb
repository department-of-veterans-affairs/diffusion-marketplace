require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
  before do
    ENV['GOOGLE_API_KEY'] = ENV['GOOGLE_TEST_API_KEY']
    @admin = User.create!(email: 'toshiro.hitsugaya@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(User::USER_ROLES[0].to_sym)
    @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline', user: @admin)
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
    login_as(@admin, :scope => :user, :run_callbacks => false)
    visit practice_adoptions_path(@practice)
    expect(page).to be_accessible.according_to :wcag2a, :section508
  end

  after do
    ENV['GOOGLE_API_KEY'] = nil
  end

  describe 'Adoptions page' do
    def open_new_adoption_form
      click_button('Add new adoption')
    end

    def select_status(status)
      label = "label[for*='status_#{status}']"
      find(label).click
    end

    def select_facility_combo_box(index)
      find('#editor_facility_select').click
      find("#editor_facility_select--list--option-#{index}").click
    end

    def submit_form
      find("button[id*='adoption_form']").click
    end

    it 'should interact with practice adoptions' do
      # it should be there
      expect(page).to have_content('Adoptions')
      expect(page).to have_link(class: 'editor-back-to-link', href: practice_introduction_path(@practice))
      expect(page).to have_link(class: 'editor-continue-link', href: practice_overview_path(@practice))

      # it should display certain parts of the form on status selection
      open_new_adoption_form
      within(:css, '#adoption_form') do
        expect(page).to have_content('Start date (optional)')
        expect(page).to have_no_content('End date (optional)')
        expect(page).to have_no_content('Why was this adoption unsuccessful?')
        select_status('completed')
        expect(page).to have_content('Start date (optional)')
        expect(page).to have_content('End date (optional)')
        expect(page).to have_no_content('Why was this adoption unsuccessful?')
        select_status('unsuccessful')
        expect(page).to have_content('Why was this adoption unsuccessful?')
        expect(page).to have_no_content('(0/50 characters)')
        select_status('in_progress')
        expect(page).to have_content('Start date (optional)')
        expect(page).to have_no_content('End date (optional)')
        expect(page).to have_no_content('Why was this adoption unsuccessful?')
      end

      # it should clear the form on cancel
      within(:css, '#adoption_form') do
        select_status('in_progress')
        select_facility_combo_box(0)
        find('#clear_entry').click
      end
      open_new_adoption_form
      within(:css, '#adoption_form') do
        expect(page.find("#status_in_progress")).not_to be_checked
        expect(page).to have_no_content('Caribou VA Clinic')
      end

      # it should not let an adoption without a facility be created
      select_status('in_progress')
      submit_form
      expect(page).to have_selector(".usa-alert--error", visible: true)
      within(:css, '#adoptions') do
        expect(page).to have_content('There was a problem with your adoption.')
        expect(page).to have_content('A facility must be selected.')
      end

      # it should create an adoption
      select_facility_combo_box(0)
      fill_in 'date_started_month', with: '12'
      fill_in 'date_started_year', with: '1990'
      submit_form
      expect(page).to have_selector(".adoption-success-alert", visible: true)
      within(:css, '#adoptions') do
        expect(page).to have_content('Success!')
        expect(page).to have_content('In-progress adoption: 1')
      end
      expect(page).to be_accessible.according_to :wcag2a, :section508

      # it should create another one
      find('#add_adoption_button').click
      select_status('in_progress')
      select_facility_combo_box(1)
      submit_form
      expect(page).to have_selector(".adoption-success-alert", visible: true)
      within(:css, '#adoptions') do
        expect(page).to have_content('Success!')
        expect(page).to have_content('In-progress adoptions: 2')
      end

      # it should update the overview section and display the adoption
      visit practice_path(@practice)
      expect(page).to have_content("In-progress adoptions (2)")
      expect(page).to have_selector("#map", visible: true)
      within(:css, ".practice-viewer-adoptions-accordion") do
        expect(page).to have_content('In-progress adoptions (2)')
        find("button[aria-controls='in_progress'").click
      end
      within(:css, "#in_progress") do
        expect(page).to have_content("ME: Caribou VA Clinic (Caribou)")
        expect(page).to have_content("Started adoption on 12/1990")
        expect(page).to have_content("NY: White Plains VA Clinic (White Plains)")
      end

      # it shouldn't create the same facility twice for a practice
      visit practice_adoptions_path(@practice)
      find('#add_adoption_button').click
      select_status('completed')
      select_facility_combo_box(0)
      submit_form
      within(:css, '#adoptions') do
        expect(page).to have_content('An adoption for Caribou VA Clinic in ME already exists in the entry list. If it is not listed, please report a bug.')
      end

      # it shouldn't create an adoption if the end date is greater than the start date
      select_status('completed')
      select_facility_combo_box(2)
      fill_in 'date_started_month', with: '11'
      fill_in 'date_started_year', with: '2000'
      fill_in 'date_ended_month', with: '3'
      fill_in 'date_ended_year', with: '1999'
      submit_form
      expect(page).to have_selector(".usa-alert--error", visible: true)
      within(:css, '#adoptions') do
        expect(page).to have_content('There was a problem with your adoption.')
        expect(page).to have_content('The start date cannot be after the end date.')
      end

      # it shouldn't create an adoption with an incomplete dates for non in-progress adoptions
      fill_in 'date_started_year', with: ''
      submit_form
      expect(page).to have_selector(".usa-alert--error", visible: true)
      within(:css, '#adoptions') do
        expect(page).to have_content('There was a problem with your adoption.')
        expect(page).to have_content('Provide a complete start date.')
      end
      fill_in 'date_started_year', with: '1998'
      fill_in 'date_ended_month', with: ''
      submit_form
      expect(page).to have_selector(".usa-alert--error", visible: true)
      within(:css, '#adoptions') do
        expect(page).to have_content('There was a problem with your adoption.')
        expect(page).to have_content('Provide a complete end date.')
      end

      # it should create an adoption with start and end dates
      fill_in 'date_ended_month', with: '3'
      submit_form
      within(:css, '#adoptions') do
        expect(page).to have_no_content('There was a problem with your adoption.')
        expect(page).to have_content('Success!')
      end
      find("button[aria-controls='successful_adoptions'").click
      within(:css, '#adoptions') do
        expect(page).to have_content('NY: Yonkers VA Clinic (11/1998 - 03/1999)')
        expect(page).to have_content('Successful adoption: 1')
      end

      # it should delete an adoption entry
      find("button[aria-controls='in-progress_adoptions'").click
      expect(page).to have_selector("#in-progress_adoptions", visible: true)
      find("button[aria-controls='diffusion_history_#{@practice.diffusion_histories.first.id}']").click
      within(:css, "#diffusion_history_#{@practice.diffusion_histories.first.id}") do
        click_link('Delete')
      end
      page.accept_alert
      expect(page).to have_content('Adoption was successfully deleted.')
      within(:css, '#adoptions') do
        expect(page).to have_content('In-progress adoption: 1')
      end

      # it shouldn't update an unsuccessful adoption if no reasons are selected
      expect(page).to have_selector(".usa-alert__heading", visible: true)
      find("button[aria-controls*='in-progress_adoptions'").click
      expect(page).to have_selector("button[aria-controls='diffusion_history_2']", visible: true)
      find_all("button[aria-controls*='diffusion_history']").first.click
      form_id = '2'
      within(:css, "#diffusion_history_#{form_id}") do
        find("label[for*='status_unsuccessful'").click
        submit_form
        expect(page).to have_content('There was a problem with your adoption.')
        expect(page).to have_content('A reason must be selected for the unsuccessful adoption.')
      end
      unsuccessful_reasons = find_all("label[for*='unsuccessful_reason']")
      unsuccessful_reasons.first.click
      unsuccessful_reasons.last.click
      expect(page).to have_content("(0/50 characters)")
      submit_form
      within(:css, '#adoptions') do
        expect(page).to have_content('There was a problem with your adoption.')
        expect(page).to have_content("Provide text for the 'Other' reason the adoption was unsuccessful.")
      end
      within(:css, "#diffusion_history_#{form_id}") do
        fill_in 'Other Reason', with: 'gAKpvmOJpIhmvVuIhGIVWaqshyvnYgyaeBvwDKXyZgkrMMPZnIOVER50CHARACTERS'
      end

      # it shouldn't update an adoption if the end date is greater than the start date
      fill_in "date_started_month#{form_id}", with: '11'
      fill_in "date_started_year#{form_id}", with: '2000'
      fill_in "date_ended_month#{form_id}", with: '3'
      fill_in "date_ended_year#{form_id}", with: '1999'
      submit_form
      within(:css, "#diffusion_history_#{form_id}") do
        expect(page).to have_content('The start date cannot be after the end date.')
      end

      # it should update an adoption with start and end dates
      fill_in "date_ended_month#{form_id}", with: '3'
      fill_in "date_ended_year#{form_id}", with: '2001'
      submit_form
      within(:css, '#adoptions') do
        expect(page).to have_no_content('There was a problem with your adoption.')
        expect(page).to have_content('Success!')
        expect(page).to have_no_content('In-progress adoption')
        expect(page).to have_content('Unsuccessful adoption: 1')
        find_all("button[aria-controls*='adoptions'").last.click
        find_all("button[aria-controls*='diffusion_history']").first.click
        expect(page).to have_content('NY: White Plains VA Clinic (11/2000 - 03/2001)')
        within(:css, "#diffusion_history_#{form_id}") do
          expect(find_field('Successful').checked?).to eq false
          expect(find_field('In-progress').checked?).to eq false
          expect(find_field('Unsuccessful').checked?).to eq true
          expect(find_field("date_started_month#{form_id}").value).to eq '11'
          expect(find_field("date_started_year#{form_id}").value).to eq '2000'
          expect(find_field("date_ended_month#{form_id}").value).to eq '3'
          expect(find_field("date_ended_year#{form_id}").value).to eq '2001'
          expect(find("#unsuccessful_reason_#{form_id}_0", visible: false).checked?).to eq true
          expect(find("#unsuccessful_reason_#{form_id}_1", visible: false).checked?).to eq false
          expect(find("#unsuccessful_reason_#{form_id}_2", visible: false).checked?).to eq false
          expect(find("#unsuccessful_reason_#{form_id}_3", visible: false).checked?).to eq false
          expect(find("#unsuccessful_reason_#{form_id}_4", visible: false).checked?).to eq false
          expect(find("#unsuccessful_reason_#{form_id}_5", visible: false).checked?).to eq true
          expect(find_field("unsuccessful_reasons_other").value).to eq "gAKpvmOJpIhmvVuIhGIVWaqshyvnYgyaeBvwDKXyZgkrMMPZnIOVER50CHARACTERS"
        end
      end

      # check the PV to make sure the adoption count is correct
      visit practice_path(@practice)
      within(:css, ".practice-viewer-adoptions-accordion") do
        expect(page).to have_content('Successful adoption (1)')
        expect(page).to have_content('In-progress adoptions (0)')
        expect(page).to have_content('Unsuccessful adoption (1)')
      end
      find("button[aria-controls='successful'").click
      within(:css, "#successful") do
        expect(page).to have_content("NY: Yonkers VA Clinic (Yonkers)")
        expect(page).to have_content("Started adoption on 11/1998, ended on 03/1999.")
      end
      find("button[aria-controls='unsuccessful'").click
      within(:css, "#unsuccessful") do
        expect(page).to have_content("NY: White Plains VA Clinic (White Plains)")
        expect(page).to have_content("Started adoption on 11/2000, ended on 03/2001.")
        expect(page).to have_content("Lack of sufficient leadership/key stakeholder buy-in")
        expect(page).to have_content("gAKpvmOJpIhmvVuIhGIVWaqshyvnYgyaeBvwDKXyZgkrMMP...")
        expect(page).to have_no_content("OVER50CHARACTERS")
      end
    end

    describe 'Adoption status tooltip' do
      def open_successful_adoption_accordion
        find("button[aria-controls='successful_adoptions'").click
      end

      def tooltip_expectations
        expect(page).to have_selector('.usa-tooltip__body', visible: false)
        find('.usa-tooltip').hover
        expect(page).to have_selector('.usa-tooltip__body', visible: true)
        expect(page).to have_content('In-progress: Facilities that have started but not completed adopting the practice.')
        expect(page).to have_content('Successful: Facilities that have met adoption goals and implemented the practice.')
        expect(page).to have_content('Unsuccessful: Facilities that started but stopped working towards adoption.')
      end

      def new_adoption_form_tooltip_flow
        open_new_adoption_form
        tooltip_expectations
      end

      def create_adoption(status, facility_index)
        open_new_adoption_form
        select_status(status)
        select_facility_combo_box(facility_index)
        submit_form
      end

      before do
        create_adoption('completed', 0)
      end

      context 'on page load' do
        it 'should display a tooltip with adoption status definitions if the user hovers over the tooltip icon within the new adoption form' do
          new_adoption_form_tooltip_flow
        end

        it 'should display a tooltip with adoption status definitions if the user hovers over the tooltip icon within an existing adoption form' do
          open_successful_adoption_accordion
          click_button('ME: Caribou VA Clinic')
          tooltip_expectations
        end
      end

      context 'after ajax call' do
        it 'should display a tooltip with adoption status definitions if the user hovers over the tooltip icon within the new adoption form' do
          create_adoption('completed', 1)
          new_adoption_form_tooltip_flow
        end

        it 'should display a tooltip with adoption status definitions if the user hovers over the tooltip icon within an existing adoption form' do
          create_adoption('completed', 2)
          open_successful_adoption_accordion
          click_button('NY: Yonkers VA Clinic')
          tooltip_expectations
        end
      end
    end
  end
end
