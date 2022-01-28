require 'rails_helper'

describe 'Admin Practice Partners Tab', type: :feature do
  before do
    @admin = User.create!(email: 'sandy.cheeks@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(:admin)
    @practice = Practice.create!(name: 'The Best Practice Ever!', initiating_facility_type: 'facility', tagline: 'Test tagline', date_initiated: 'Sun, 05 Feb 1992 00:00:00 UTC +00:00', summary: 'This is the best practice ever.', overview_problem: 'overview-problem', published: true, approved: true, user: @admin)
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
      fill_in('Name', with: @practice_partner.name)
      click_button('Create Practice partner')

      expect(page).to have_content('There was an error. A practice partner with the slug: practice-partner-1 already exists.')
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
      fill_in('Name', with: 'Updated Practice Partner 1')
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
      fill_in('Name', with: 'New Practice Partner')
      check('Major practice partner?')
      click_button('Create Practice partner')
      expect(cache_keys).not_to include('practice_partners')
      add_practice_partners_to_cache
      find('.search-filters-accordion-button').click
      expect(page).to have_content('New Practice Partner')
    end

    it 'Should be reset if a new practice is added to an existing practice partner' do
      # make sure the practice is present without the partner
      add_practice_partners_to_cache
      expect(page).to have_content('1 result')
      expect(page).to have_content(@practice.name)
      visit '/admin/practice_partners'
      click_link('Edit', href: edit_admin_practice_partner_path(@practice_partner))
      # add a practice to the partner
      find("option[value='1']").click
      click_button('Update Practice partner')
      expect(cache_keys).not_to include('searchable_practices')
      # make sure the cache has been reset and that the practice is now associated with the practice partner
      add_practice_partners_to_cache
      find('.search-filters-accordion-button').click
      all('.practice-partner-search-checkbox-label')[0].click
      find('#dm-practice-search-button').click
      expect(page).to have_content('1 result')
      expect(page).to have_content(@practice.name)
    end

    it 'Should be reset if a practice is deleted from an existing practice partner' do
      # make sure the practice is present with the partner
      PracticePartnerPractice.create!(practice_partner: @practice_partner, practice: @practice)
      add_practice_partners_to_cache
      find('.search-filters-accordion-button').click
      all('.practice-partner-search-checkbox-label')[0].click
      find('#dm-practice-search-button').click
      expect(page).to have_content('1 result')
      expect(page).to have_content(@practice.name)
      visit '/admin/practice_partners'
      click_link('Edit', href: edit_admin_practice_partner_path(@practice_partner))
      # remove the practice from the partner
      all('#practice_partner_practice_ids option')[1].click
      all('#practice_partner_practice_ids option')[0].click
      click_button('Update Practice partner')
      expect(cache_keys).not_to include('searchable_practices')
      # make sure the cache has been reset and that the practice is no longer associated with the practice partner
      add_practice_partners_to_cache
      find('.search-filters-accordion-button').click
      all('.practice-partner-search-checkbox-label')[0].click
      find('#dm-practice-search-button').click
      expect(page).to_not have_content('1 result')
      expect(page).to_not have_content(@practice.name)
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