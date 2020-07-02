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
      find('#practice_partner_1_label').click
      @save_button.click

      expect(page).to have_field('practice_name', with: 'A public practice')
      expect(all('.partner-input').first).to be_checked

      # go to impact page since publishing on overview with empty required fields results in form warnings
      visit practice_impact_path(@practice)
      @publish_button.click
      expect(page).to have_content('Cannot publish yet')
      expect(page).to have_content('You must include a practice tagline')
      expect(page).to have_content('You must include the initiation date for your practice')
      expect(page).to have_content('You must include the initiating facility for your practice')
      expect(page).to have_content('You must include a practice summary')
      expect(page).to have_content('You must include a support network email')
    end

    it 'Should save and publish the practice if all required fields are met' do
      tagline = 'Super duper'
      initiated_month = 'October'
      initiated_year = '1970'
      summary = 'This is the most super practice ever made'

      visit practice_contact_path(@practice)
      email = 'test@email.com'
      fill_in('Email:', with: email)
      @save_button.click
      expect(page).to have_field('Email:', with: email)

      visit practice_overview_path(@practice)
      fill_in('practice_tagline', with: tagline)
      all('.initiating-facility-type-label').first.click
      select('Alabama', :from => 'editor_state_select')
      select('Birmingham VA Medical Center', :from => 'editor_facility_select')
      select(initiated_month, :from => 'editor_date_intiated_month')
      select(initiated_year, :from => 'editor_date_intiated_year')
      fill_in('Practice summary:', with: summary)

      @publish_button.click
      expect(page).to have_content(tagline)
      expect(page).to have_content(summary)
      expect(page).to have_content('October 1970')
      expect(page).to have_content('Birmingham VA Medical Center')
      expect(page).to have_content('A public practice')
      expect(page).to_not have_content('Cannot publish yet')
      expect(page).to have_content("#{@practice.name} has been successfully published to the Diffusion Marketplace")
      # Publish button should be gone if the practice has been published
      expect(page).to_not have_link('Publish practice')
    end
  end
end
