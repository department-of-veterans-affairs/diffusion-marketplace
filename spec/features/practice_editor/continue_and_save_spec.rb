require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
  before do
    @admin = User.create!(email: 'retsu.unohana@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline', user: @admin)
    @admin.add_role(User::USER_ROLES[0].to_sym)
  end

  describe 'Continue button' do
    before do
      login_as(@admin, :scope => :user, :run_callbacks => false)
    end

    it 'should save the users work and advance them to the next page in the editor when clicked' do
      visit practice_implementation_path(@practice)
      time_frame = '1'
      milestone = 'week to complete this milestone'
      core_people_resource = 'A practice person'
      find('#link_to_add_button_timeline').click
      fill_in('Time frame', with: time_frame)
      fill_in('Description of milestones (include context or disclaimers as needed)', with: milestone)
      fill_in('Resource', with: core_people_resource)
      find('.continue-and-save').click

      @practice.reload
      expect(page).to have_content('Innovation was successfully updated')
      expect(page).to have_content('Contact')
      expect(page).to have_content('This section helps people to reach out for support, ask questions, and connect about your innovation.')
      expect(@practice.timelines.first.timeline).to eq(time_frame)
      expect(@practice.timelines.first.milestone).to eq(milestone)

      main_email = 'test@test.com'

      fill_in('Main email address', with: main_email)
      find('.continue-and-save').click

      @practice.reload
      expect(page).to have_content('Innovation was successfully updated')
      expect(page).to have_content('About')
      expect(@practice.support_network_email).to eq(main_email)
    end

    it 'should not allow a user to move to the next page if there is a required field not filled out' do
      visit practice_overview_path(@practice)
      find('.continue-and-save').click
      email_message = all('.practice-editor-overview-statement-input').first.native.attribute('validationMessage')
      expect(email_message).to eq('Please fill out this field.')
    end
  end
end