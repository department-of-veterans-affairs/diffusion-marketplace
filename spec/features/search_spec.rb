require 'rails_helper'

describe 'Search', type: :feature do
  before do
    @user = User.create!(email: 'spongebob.squarepants@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @user2 = User.create!(email: 'patrick.star@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin = User.create!(email: 'sandy.cheeks@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @approver = User.create!(email: 'squidward.tentacles@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(User::USER_ROLES[1].to_sym)
    @approver.add_role(User::USER_ROLES[0].to_sym)
    @practice = Practice.create!(name: 'The Best Practice Ever!', initiating_facility: '631HC', tagline: 'Test tagline', date_initiated: 'Sun, 05 Feb 1992 00:00:00 UTC +00:00', summary: 'This is the best practice ever.')
    @practice2 = Practice.create!(name: 'Another Best Practice', initiating_facility: '687HA', tagline: 'Test tagline 2', date_initiated: 'Sun, 24 Oct 2004 00:00:00 UTC +00:00', summary: 'This is another best practice.')
  end

  def update_practice(practice)
    login_as(@admin, :scope => :user, :run_callbacks => false)
    visit practice_overview_path(practice)
    all('.initiating-facility-type-label').first.click
    select('Alabama', :from => 'editor_state_select')
    select('Birmingham VA Medical Center', :from => 'editor_facility_select')
    fill_in('practice_summary', with: 'This is the most super practice ever made')
    find('#practice-editor-save-button').click
  end

  def user_login
    login_as(@user, :scope => :user, :run_callbacks => false)
  end

  def visit_search_page
    visit '/search'
  end

  def search
    find('#dm-practice-search-button').click
  end

  def publish_practice(practice)
    login_as(@admin, :scope => :user, :run_callbacks => false)
    visit practice_overview_path(practice)
    fill_in('practice_tagline', with: 'Test tagline.')
    all('.initiating-facility-type-label').first.click
    select('Alabama', :from => 'editor_state_select')
    select('Birmingham VA Medical Center', :from => 'editor_facility_select')
    fill_in('practice_summary', with: 'This is the most super practice ever made')
    select('October', :from => 'editor_date_intiated_month')
    select('1970', :from => 'editor_date_intiated_year')
    find('#practice-editor-save-button').click
    visit(practice_contact_path(practice))
    fill_in('practice_support_network_email', with: 'dm@va.gov')
    click_button('Publish')
  end

  def cache_keys
    Rails.cache.redis.keys
  end

  def add_search_to_cache
    user_login
    visit_search_page
    fill_in('dm-practice-search-field', with: 'Test')
    search
  end

  describe 'results' do
    it 'should show practices that are approved and published' do
      @practice.update(published: true, approved: true)
      user_login
      visit_search_page
      expect(page).to be_accessible.according_to :wcag2a, :section508

      fill_in('dm-practice-search-field', with: 'Test')
      search

      expect(page).to be_accessible.according_to :wcag2a, :section508

      # test facility data map for name, negative case
      expect(page).to have_content(@practice.name)
      expect(page).to have_content(@practice.initiating_facility)
      expect(page).to have_content('1 result for Test')

      # do not show a practice that is not approved/published
      fill_in('dm-practice-search-field', with: 'practice')
      find('#dm-practice-search-button').click

      expect(page).to have_content('1 result for practice')

      # show practices that are approved/published
      @practice2.update(published: true, approved: true)
      visit_search_page
      fill_in('dm-practice-search-field', with: 'practice')
      search

      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_content(@practice.name)
      expect(page).to have_content(@practice2.name)
      expect(page).to have_content('2 results for practice')

      # test facility data map for name, positive case
      expect(page).to have_content('Yakima VA Clinic')
    end

    it 'should be able to search based on practice categories' do
      category = Category.create!(name: 'telehealth')
      CategoryPractice.create!(category: category, practice: @practice)
      @practice.update(published: true, approved: true)

      visit '/search'

      fill_in('dm-practice-search-field', with: 'Telehealth')
      find('#dm-practice-search-button').click

      expect(page).to have_content(@practice.name)
      expect(page).to have_content(@practice.initiating_facility)
      expect(page).to have_content('1 result for Telehealth')
    end

    it 'should be able to search based on practice categories related terms' do
      category = Category.create!(name: 'Covid')
      CategoryPractice.create!(category: category, practice: @practice)
      category.update(related_terms: ['Coronavirus'])
      @practice.update(published: true, approved: true)

      visit '/search'

      fill_in('dm-practice-search-field', with: 'Coronavirus')
      find('#dm-practice-search-button').click

      expect(page).to have_content(@practice.name)
      expect(page).to have_content(@practice.initiating_facility)
      expect(page).to have_content('1 result for Coronavirus')
    end
  end

  describe 'Cache' do
    it 'Should be reset if certain practice attributes have been updated' do
      add_search_to_cache

      expect(cache_keys).to include("searchable_practices")

      update_practice(@practice)

      expect(cache_keys).to include("searchable_practices")
    end

    it 'Should be reset if a new practice is created through the admin panel' do
      add_search_to_cache

      expect(cache_keys).to include("searchable_practices")

      login_as(@admin, :scope => :user, :run_callbacks => false)
      visit '/admin'
      click_link('Practices')
      click_link('New Practice')
      fill_in('Practice name', with: 'The Newest Practice')
      fill_in('User email', with: 'practice_owner@va.gov')
      click_button('Create Practice')
      latest_practice = Practice.last

      visit '/search?=newest'
      expect(page).to_not have_content(latest_practice.name)

      publish_practice(latest_practice)
      expect(cache_keys).to include("searchable_practices")

      find('h1#overview', text: latest_practice.name)
      expect(Practice.searchable_practices.last.name).to eq(latest_practice.name)

      visit '/search?=newest'
      expect(page).to have_content('1 result for newest')
      expect(page).to have_content(latest_practice.name)
    end
  end
end
