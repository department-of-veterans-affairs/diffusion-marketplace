require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
  before do
    @admin = User.create!(email: 'toshiro.hitsugaya@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @approver = User.create!(email: 'tosen.kaname@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @user = User.create!(email: 'jushiro.ukitake@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline')
    @admin.add_role(User::USER_ROLES[0].to_sym)
    @approver.add_role(User::USER_ROLES[0].to_sym)
    @user_practice = Practice.create!(name: 'The Best Practice Ever!', user: @user, initiating_facility: 'Test facility name', tagline: 'Test tagline')
  end

  describe 'Risk and Mitigation page' do
    before do
      login_as(@admin, :scope => :user, :run_callbacks => false)
      visit practice_risk_and_mitigation_path(@practice)
      expect(page).to be_accessible.according_to :wcag2a, :section508
      @save_progress = find('#practice-editor-save-button')
      @risk_text = 'This is super risky.'
      @mitigation_text = 'This is how we mitigate said risk.'
    end

    it 'should be there' do
      expect(page).to have_content('Checklist')
      expect(page).to have_link(href: practice_timeline_path(@practice))
      expect(page).to have_link(href: practice_contact_path(@practice))
    end

    # it 'should require the user to fill out the fields that are marked as required' do
    #   find('.add-risk-mitigation-link').click
    #   @save_progress.click
    #   expect(page).to be_accessible.according_to :wcag2a, :section508
    #
    #   risk_message = page.find('.risk-description-textarea').native.attribute('validationMessage')
    #   expect(risk_message).to eq('Please fill out this field.')
    #
    #   fill_in('Risk', with: @risk_text)
    #   @save_progress.click
    #   mitigation_message = page.find('.mitigation-description-textarea ').native.attribute('validationMessage')
    #   expect(mitigation_message).to eq('Please fill out this field.')
    # end

    def fill_in_risk_mitigation
      find('.add-risk-mitigation-link').click
      fill_in('Risk', with: @risk_text)
      fill_in('Mitigation', with: @mitigation_text)
    end

    it 'when no data is present, should allow the user to add a risk and mitigation pair' do
      fill_in_risk_mitigation

      @save_progress.click
      expect(page).to have_current_path(practice_risk_and_mitigation_path(@practice))

      expect(page).to have_content('Practice was successfully updated.')
      expect(page).to have_field('practice[risk_mitigations_attributes][0][risks_attributes][0][description]', with: @risk_text)
      expect(page).to have_field('practice[risk_mitigations_attributes][0][mitigations_attributes][0][description]', with: @mitigation_text)
    end

    it 'should allow the user to add multiple risk and mitigation pairs' do
      risk_text_2 = 'It is not going to happen.'
      mitigation_text_2 = 'We make it happen.'

      fill_in_risk_mitigation

      find('.add-risk-mitigation-link').click

      all('.risk-description-textarea').last.set(risk_text_2)
      all('.mitigation-description-textarea').last.set(mitigation_text_2)

      find('#practice-editor-save-button').click

      expect(page).to be_accessible.according_to :wcag2a, :section508

      expect(page).to have_content('Practice was successfully updated')
      expect(page).to have_field('practice[risk_mitigations_attributes][0][risks_attributes][0][description]', with: @risk_text)
      expect(page).to have_field('practice[risk_mitigations_attributes][0][mitigations_attributes][0][description]', with: @mitigation_text)
      expect(page).to have_field('practice[risk_mitigations_attributes][1][risks_attributes][0][description]', with: risk_text_2)
      expect(page).to have_field('practice[risk_mitigations_attributes][1][mitigations_attributes][0][description]', with: mitigation_text_2)
    end

    it 'should allow the user to delete risk and mitigation pairs' do
      fill_in_risk_mitigation

      @save_progress.click

      find('.risk-mitigation-trash').click
      expect(page).to be_accessible.according_to :wcag2a, :section508

      @save_progress.click
      expect(page).not_to have_content('Risk: Type the name or description of the risk.')
    end

    it 'should allow a user to continue if there are no risk and mitigations pair made' do
      click_link 'Continue'
      expect(page).to have_current_path(practice_contact_path(@practice))
    end
  end
end