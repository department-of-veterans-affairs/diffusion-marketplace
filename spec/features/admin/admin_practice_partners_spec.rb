require 'rails_helper'

describe 'Admin Practice Partners Tab', type: :feature do
  before do
    @admin = User.create!(email: 'sandy.cheeks@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(:admin)
    @practice_partner = PracticePartner.create!(name: 'Practice Partner 1', is_major: true)
    @practice_partner2 = PracticePartner.create!(name: 'Practice Partner 2')
    login_as(@admin, scope: :user, run_callbacks: false)
    visit '/admin/practice_partners'
  end

  describe 'Validations' do
    it 'should not allow a user to create a practice partner without a name' do
      click_link('New Practice Partner')
      click_button('Create Practice partner')

      expect(page).to have_content('There was an error. Practice partner name cannot be blank.')
    end

    it 'should not allow a user to create a practice partner with a name that already exists in the DB' do
      click_link('New Practice Partner')
      fill_in('Practice partner name', with: @practice_partner.name)
      click_button('Create Practice partner')

      expect(page).to have_content('There was an error. Practice Partner 1 practice partner already exists.')
    end
  end

  describe 'Editing practice partners' do
    it 'should allow a user to update a practice partner\'s \'is_major\' attribute from both the index page and the edit page' do
      # index page
      click_link('Make major')
      expect(page).to have_content("\"Practice Partner 2\" is now a major practice partner.")
      click_link('Make minor', href: set_practice_partner_importance_admin_practice_partner_path(@practice_partner2))
      expect(page).to have_content("\"Practice Partner 2\" is now a minor practice partner.")

      # edit page
      click_link('Edit', href: edit_admin_practice_partner_path(@practice_partner))
      check('Major practice partner?')
      click_button('Update Practice partner')

      expect(page).to have_content('Practice partner was successfully updated.')
      click_link('Edit', href: edit_admin_practice_partner_path(@practice_partner))
      expect(find('#practice_partner_is_major')).to be_checked
    end
  end

  describe 'Cache' do
    it 'Should be reset if a practice partner has been changed' do
      add_practice_partners_to_cache
      visit '/admin/practice_partners'
      click_link('Edit', href: edit_admin_practice_partner_path(@practice_partner))
      fill_in('Practice partner name', with: 'Updated Practice Partner 1')
      click_button('Update Practice partner')
      expect(cache_keys).not_to include('practice_partners')
      add_practice_partners_to_cache
      find('.search-filters-accordion-button').click
      expect(page).to have_content('Updated Practice Partner 1')
    end

    it 'Should be reset if a new practice partner is created through the admin panel' do
      add_practice_partners_to_cache
      visit '/admin/practice_partners'
      click_link('New Practice Partner')
      fill_in('Practice partner name', with: 'New Practice Partner')
      check('Major practice partner?')
      click_button('Create Practice partner')
      expect(cache_keys).not_to include('practice_partners')
      add_practice_partners_to_cache
      find('.search-filters-accordion-button').click
      expect(page).to have_content('New Practice Partner')
    end
  end

  def add_practice_partners_to_cache
    visit '/search'
    expect(cache_keys).to include('practice_partners')
  end

  def cache_keys
    Rails.cache.redis.keys
  end
end