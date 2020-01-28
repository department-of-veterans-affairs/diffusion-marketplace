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

  describe 'Checklist page' do
    before do
      login_as(@admin, :scope => :user, :run_callbacks => false)
      visit practice_checklist_path(@practice)
      expect(page).to be_accessible.according_to :wcag2a, :section508
    end

    it 'should be there' do
      expect(page).to have_content('Checklist')
      expect(page).to have_link(class: 'editor-back-to-link', href: "/practices/#{@practice.slug}/edit/contact")
      expect(page).to have_link(class: 'editor-continue-link', href: "/practices/#{@practice.slug}/publication_validation")
    end

    fit 'when no data is present, should allow the user to add a practice permission and additional resource' do
      within(:css, '#sortable_permissions') do
        fill_in('Step', with: 'Step 1')
        fill_in('Description', with: 'Description 1')

      end
    end

    it 'should allow the user to update the data on the page' do
      fill_in('practice_name', with: 'A super practice')
      fill_in('practice_tagline', with: 'Super duper')
      select('Alabama', :from => 'editor_state_select')
      select('Birmingham VA Medical Center', :from => 'editor_facility_select')
      fill_in('practice_summary', with: 'This is the most super practice ever made')
      find('#practice_partner_1_label').click
      find('#practice-editor-save-button').click
      expect(page).to have_field('practice_name', with: 'A super practice')
      expect(page).to have_field('practice_tagline', with: 'Super duper')
      expect(page).to have_field('practice_summary', with: 'This is the most super practice ever made')
    end
    it 'should show an alert window if no practice partners were chosen' do
      select('Alabama', :from => 'editor_state_select')
      select('Birmingham VA Medical Center', :from => 'editor_facility_select')
      fill_in('practice_summary', with: 'This is the most super practice ever made')
      find('#practice-editor-save-button').click
      expect(accept_alert).to eq('Please choose at least one of the partners listed')
    end
    it 'should require the user to fill out the fields that are marked as required' do
      find('#practice_partner_1_label').click
      fill_in('practice_name', with: nil)
      find('#practice-editor-save-button').click
      name_message = page.find("#practice_name").native.attribute("validationMessage")
      expect(name_message).to eq('Please fill out this field.')
      fill_in('practice_name', with: 'A public practice')
      find('#practice-editor-save-button').click
      state_message = page.find("#editor_state_select").native.attribute("validationMessage")
      expect(state_message).to eq('Please select an item in the list.')
      select('Alabama', :from => 'editor_state_select')
      select('Birmingham VA Medical Center', :from => 'editor_facility_select')
      find('#practice-editor-save-button').click
      summary_message = page.find("#practice_summary").native.attribute("validationMessage")
      expect(summary_message).to eq('Please fill out this field.')
    end
  end
end