require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
  before do
    @admin = User.create!(email: 'toshiro.hitsugaya@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: false)
    @practice_partner = PracticePartner.create!(name: 'Diffusion of Excellence', short_name: '', description: 'The Diffusion of Excellence Initiative', icon: 'fas fa-heart', color: '#E4A002')
    @admin.add_role(User::USER_ROLES[0].to_sym)
  end

  describe 'Publish practice flow' do
    before do
      login_as(@admin, :scope => :user, :run_callbacks => false)
      visit practice_overview_path(@practice)
      expect(page).to be_accessible.according_to :wcag2a, :section508
      @save_button = find('#practice-editor-save-button')
      @publish_button = find('#publish-practice-button')
    end

    it 'Should display an error modal that contains missing required fields if any exist' do
      adoptions = '13'
      fill_in('practice_number_adopted', with: adoptions)
      find('#practice_partner_1_label').click
      @save_button.click

      expect(page).to have_field('practice_name', with: 'A public practice')
      expect(page).to have_field('practice_number_adopted', with: adoptions)
      expect(all('.partner-input').first).to be_checked

      @publish_button.click
      expect(page).to have_content('Cannot publish yet')
      expect(page).to have_content('You must include a practice tagline')
      expect(page).to have_content('You must include the initiation date for your practice')
      expect(page).to have_content('You must include the initiating facility for your practice')
      expect(page).to have_content('You must include a practice summary')
      expect(page).to have_content('You must include a support network email')
    end

    it 'Should publish the practice if all required fields are met' do
      tagline = 'Super duper'
      initiated_month = 'October'
      initiated_year = '1970'
      summary = 'This is the most super practice ever made'
      fill_in('practice_tagline', with: tagline)
      select('Alabama', :from => 'editor_state_select')
      select('Birmingham VA Medical Center', :from => 'editor_facility_select')
      select(initiated_month, :from => 'editor_date_intiated_month')
      select(initiated_year, :from => 'editor_date_intiated_year')
      fill_in('Practice summary:', with: summary)
      @save_button.click

      expect(page).to have_field('practice_tagline', with: tagline)
      expect(page).to have_field('practice_summary', with: summary)
      expect(page).to have_field('Month', with: '10')
      expect(page).to have_field('Year', with: initiated_year)
      expect(page).to have_field('State', with: 'AL')
      expect(page).to have_field('Facility', with: '521')

      visit practice_contact_path(@practice)
      email = 'test@email.com'
      fill_in('Email:', with: email)
      @save_button.click

      expect(page).to have_field('Email:', with: email)

      @publish_button.click
      expect(page).to have_content('A public practice')
      expect(page).to_not have_content('Cannot publish yet')
      expect(page).to have_content("#{@practice.name} has been successfully published to the Diffusion Marketplace")
      # Publish button should be gone if the practice has been published
      expect(page).to_not have_link('Publish practice')
    end
  end
end
