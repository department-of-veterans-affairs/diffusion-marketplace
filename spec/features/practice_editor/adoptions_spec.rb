require 'rails_helper'

describe 'Practice editor', type: :feature do
  before do
    @admin = User.create!(email: 'toshiro.hitsugaya@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @approver = User.create!(email: 'tosen.kaname@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @user = User.create!(email: 'jushiro.ukitake@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline')
    @admin.add_role(User::USER_ROLES[0].to_sym)
    @approver.add_role(User::USER_ROLES[0].to_sym)
    @user_practice = Practice.create!(name: 'The Best Practice Ever!', user: @user, initiating_facility: 'Test facility name', tagline: 'Test tagline')
  end

  describe 'Adoptions page' do
    before do
      login_as(@admin, :scope => :user, :run_callbacks => false)
      visit practice_adoptions_path(@practice)
      expect(page).to be_accessible.according_to :wcag2a, :section508
    end

    it 'should interact with practice adoptions' do
      # it should be there
      expect(page).to have_content('Adoptions')
      expect(page).to have_link(class: 'editor-back-to-link', href: practice_introduction_path(@practice))
      expect(page).to have_link(class: 'editor-continue-link', href: practice_overview_path(@practice))

      # new entry form should clear the entry when "Clear entry" is clicked
      find('#add_adoption_button').click
      find('label[for="status_in_progress"').click
      select('Alabama', :from => 'editor_state_select')
      select('Birmingham VA Medical Center', :from => 'editor_facility_select')
      # alternate name of facility should be displayed
      expect(page).to have_content('(Birmingham-Alabama)')
      # clear Entry now hides the form 10/22/20
      find('#clear_entry').click
      # show the form again
      find('#add_adoption_button').click
      expect(page).to have_field('State', with: '')

      # it should create an adoption
      find('label[for="status_in_progress"').click
      select('Alaska', :from => 'editor_state_select')
      select('Anchorage VA Medical Center', :from => 'editor_facility_select')
      find('#adoption_form_submit').click

      expect(page).to be_accessible.according_to :wcag2a, :section508
      within(:css, '#adoptions') do
        expect(page).to have_content('Success!')
        expect(page).to have_content('In-progress adoptions (1)')
      end

      # it should update the overview section with the correct number of facility adoptions
      visit practice_path(@practice)
      expect(page).to have_content('1 in-progress')

      # make another one
      visit practice_adoptions_path(@practice)
      find('#add_adoption_button').click
      find('label[for="status_in_progress"').click
      select('Alaska', :from => 'editor_state_select')
      select('Fairbanks VA Clinic', :from => 'editor_facility_select')
      find('#adoption_form_submit').click

      visit practice_path(@practice)
      expect(page).to have_content('2 in-progress')

      # it shouldn't let the system create the same facility twice for a practice
      visit practice_adoptions_path(@practice)
      find('#add_adoption_button').click
      find('label[for="status_in_progress"').click
      select('Alaska', :from => 'editor_state_select')
      select('Fairbanks VA Clinic', :from => 'editor_facility_select')
      find('#adoption_form_submit').click

      within(:css, '#adoptions') do
        expect(page).to have_content('An adoption for Fairbanks VA Clinic in AK already exists in the entry list. If it is not listed, please report a bug.')
      end

      # it shouldn't let the system update the facility if the facility already exists for a practice
      find("button[aria-controls='in-progress_adoptions'").click
      find("button[aria-controls='diffusion_history_#{@practice.diffusion_histories.first.id}']").click
      select('Fairbanks VA Clinic', :from => "editor_facility_select_#{@practice.diffusion_histories.first.id}")
      find("#adoption_form#{@practice.diffusion_histories.first.id}_submit").click
      within(:css, "#diffusion_history_#{@practice.diffusion_histories.first.id}") do
        expect(page).to have_content('An adoption for Fairbanks VA Clinic in AK already exists in the entry list. If it is not listed, please report a bug.')
      end

      # it shouldn't let the system create an adoption if the end date is greater than the start date
      find('#add_adoption_button').click
      find('label[for="status_completed"').click
      select('Alaska', :from => 'editor_state_select')
      select('Homer VA Clinic', :from => 'editor_facility_select')
      select('December', :from => 'date_started_month')
      select('2020', :from => 'date_started_year')
      select('January', :from => 'date_ended_month')
      select('2010', :from => 'date_ended_year')
      find('#adoption_form_submit').click
      within(:css, '#adoptions') do
        expect(page).to have_content('The start date cannot be after the end date.')
      end

      # it should let the system create an adoption with start and end dates
      select('January', :from => 'date_started_month')
      select('2010', :from => 'date_started_year')
      select('December', :from => 'date_ended_month')
      select('2020', :from => 'date_ended_year')
      find('#adoption_form_submit').click
      within(:css, '#adoptions') do
        expect(page).not_to have_content('The start date cannot be after the end date.')
        expect(page).to have_content('Success!')
      end
      find("button[aria-controls='successful_adoptions'").click
      expect(page).to have_content('AK: Homer VA Clinic (01/2010 - 12/2020)')

      # it shouldn't let the system update an adoption if the end date is greater than the start date
      find("button[aria-controls='in-progress_adoptions'").click
      find("button[aria-controls='diffusion_history_#{@practice.diffusion_histories.first.id}']").click
      find("label[for='status_unsuccessful#{@practice.diffusion_histories.first.id}'").click
      select('December', :from => "date_started_month#{@practice.diffusion_histories.first.id}")
      select('2020', :from => "date_started_year#{@practice.diffusion_histories.first.id}")
      select('January', :from => "date_ended_month#{@practice.diffusion_histories.first.id}")
      select('2010', :from => "date_ended_year#{@practice.diffusion_histories.first.id}")
      find("#adoption_form#{@practice.diffusion_histories.first.id}_submit").click
      within(:css, "#diffusion_history_#{@practice.diffusion_histories.first.id}") do
        expect(page).to have_content('The start date cannot be after the end date.')
      end

      # it should let the system update an adoption with start and end dates
      select('February', :from => "date_started_month#{@practice.diffusion_histories.first.id}")
      select('2010', :from => "date_started_year#{@practice.diffusion_histories.first.id}")
      select('November', :from => "date_ended_month#{@practice.diffusion_histories.first.id}")
      select('2020', :from => "date_ended_year#{@practice.diffusion_histories.first.id}")
      find("#adoption_form#{@practice.diffusion_histories.first.id}_submit").click
      expect(page).to have_content('AK: Anchorage VA Medical Center (02/2010 - 11/2020)')

      # check the PV to make sure the adoption count is correct
      visit practice_path(@practice)
      expect(page).to have_content('1 successful, 1 in-progress, 1 unsuccessful')

      # it should let the system update delete an adoption entry
      visit practice_adoptions_path(@practice)
      find("button[aria-controls='unsuccessful_adoptions'").click
      find("button[aria-controls='diffusion_history_#{@practice.diffusion_histories.first.id}']").click
      within(:css, "#diffusion_history_#{@practice.diffusion_histories.first.id}") do
        click_link('Delete entry')
      end
      page.accept_alert
      expect(page).to have_content('Adoption entry was successfully deleted.')
    end

    describe 'Adoption status tooltip' do
      def open_new_adoption_form
        click_button('Add new adoption')
      end

      def open_successful_adoption_accordion
        click_button('Successful adoptions (1)')
        click_button('FL: Boca Raton VA Clinic (TBD - TBD)')
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

      def create_adoption(state, facility)
        open_new_adoption_form
        find('label[for="status_completed"').click
        select("#{state}", :from => 'editor_state_select')
        select("#{facility}", :from => 'editor_facility_select')
        find('#adoption_form_submit').click
      end

      before do
        create_adoption('Florida', 'Boca Raton VA Clinic')
      end

      context 'on page load' do
        it 'should display a tooltip with adoption status definitions if the user hovers over the tooltip icon within the new adoption form' do
          new_adoption_form_tooltip_flow
        end

        it 'should display a tooltip with adoption status definitions if the user hovers over the tooltip icon within an existing adoption form' do
          click_button('Successful adoptions (1)')
          click_button('FL: Boca Raton VA Clinic (TBD - TBD)')
          tooltip_expectations
        end
      end

      context 'after ajax call' do
        it 'should display a tooltip with adoption status definitions if the user hovers over the tooltip icon within the new adoption form' do
          create_adoption('Alaska', 'Anchorage VA Medical Center')
          new_adoption_form_tooltip_flow
        end

        it 'should display a tooltip with adoption status definitions if the user hovers over the tooltip icon within an existing adoption form' do
          create_adoption('Alaska', 'Homer VA Clinic')
          click_button('Successful adoptions (2)')
          click_button('AK: Homer VA Clinic (TBD - TBD)')
          tooltip_expectations
        end
      end
    end
  end
end