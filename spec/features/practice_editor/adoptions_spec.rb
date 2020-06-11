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
      expect(page).to have_link(class: 'editor-back-to-link', href: practice_overview_path(@practice))
      expect(page).to have_link(class: 'editor-continue-link', href: practice_origin_path(@practice))

      # new entry form should clear the entry when "Clear entry" is clicked
      find('button[aria-controls="a0"]').click
      find('label[for="status_in_progress"').click
      select('Alabama', :from => 'editor_state_select')
      select('Birmingham VA Medical Center', :from => 'editor_facility_select')
      # alternate name of facility should be displayed
      expect(page).to have_content('(Birmingham-Alabama)')
      find('#clear_entry').click
      expect(page).to have_field('State', with: '')

      # it should create an adoption
      find('label[for="status_in_progress"').click
      select('Alaska', :from => 'editor_state_select')
      select('Anchorage VA Medical Center', :from => 'editor_facility_select')
      find('#adoption_form_submit').click

      expect(page).to be_accessible.according_to :wcag2a, :section508
      within(:css, '#adoptions') do
        expect(page).to have_content('Success!')
      end

      # it should update the overview section with the correct number of facility adoptions
      visit practice_path(@practice)
      expect(page).to have_content('1 facility has adopted this practice')

      # make another one
      visit practice_adoptions_path(@practice)
      find('button[aria-controls="a0"]').click
      find('label[for="status_in_progress"').click
      select('Alaska', :from => 'editor_state_select')
      select('Fairbanks VA Clinic', :from => 'editor_facility_select')
      find('#adoption_form_submit').click

      visit practice_path(@practice)
      expect(page).to have_content('2 facilities have adopted this practice')

      # it shouldn't let the system create the same facility twice for a practice
      visit practice_adoptions_path(@practice)
      find('button[aria-controls="a0"]').click
      find('label[for="status_in_progress"').click
      select('Alaska', :from => 'editor_state_select')
      select('Fairbanks VA Clinic', :from => 'editor_facility_select')
      find('#adoption_form_submit').click

      within(:css, '#adoptions') do
        expect(page).to have_content('An adoption for Fairbanks VA Clinic in AK already exists in the entry list. If it is not listed, please report a bug.')
      end

      # it shouldn't let the system update the facility if the facility already exists for a practice
      find("button[aria-controls='diffusion_history_#{@practice.diffusion_histories.first.id}']").click
      select('Fairbanks VA Clinic', :from => "editor_facility_select_#{@practice.diffusion_histories.first.id}")
      find("#adoption_form#{@practice.diffusion_histories.first.id}_submit").click
      within(:css, "#diffusion_history_#{@practice.diffusion_histories.first.id}") do
        expect(page).to have_content('An adoption for Fairbanks VA Clinic in AK already exists in the entry list. If it is not listed, please report a bug.')
      end

      # it shouldn't let the system create an adoption if the end date is greater than the start date
      find('button[aria-controls="a0"]').click
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
      expect(page).to have_content('Completed Homer VA Clinic 01/2010 - 12/2020')

      # it shouldn't let the system update an adoption if the end date is greater than the start date
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
      expect(page).to have_content('Unsuccessful Anchorage VA Medical Center 02/2010 - 11/2020')

      # it shouldn't count "Unsuccessful" status adoptions
      visit practice_path(@practice)
      # it would say "3" here if the "Unsuccessful" were counted
      expect(page).to have_content('2 facilities have adopted this practice')

      # it should let the system update delete an adoption entry
      visit practice_adoptions_path(@practice)
      find("button[aria-controls='diffusion_history_#{@practice.diffusion_histories.first.id}']").click
      within(:css, "#diffusion_history_#{@practice.diffusion_histories.first.id}") do
        click_link('Delete entry')
      end
      page.accept_alert
      expect(page).to have_content('Adoption entry was successfully deleted.')
    end
  end
end