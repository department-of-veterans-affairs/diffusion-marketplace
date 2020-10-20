require 'rails_helper'

describe 'Search', type: :feature do
  before do
    @user = User.create!(email: 'spongebob.squarepants@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @user2 = User.create!(email: 'patrick.star@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin = User.create!(email: 'sandy.cheeks@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @approver = User.create!(email: 'squidward.tentacles@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(User::USER_ROLES[1].to_sym)
    @approver.add_role(User::USER_ROLES[0].to_sym)
    @practice = Practice.create!(name: 'The Best Practice Ever!', initiating_facility_type: 'facility', tagline: 'Test tagline', date_initiated: 'Sun, 05 Feb 1992 00:00:00 UTC +00:00', summary: 'This is the best practice ever.')
    PracticeOriginFacility.create!(practice: @practice, facility_type: 0, facility_id: '640A0')
    @practice2 = Practice.create!(name: 'Another Best Practice', initiating_facility_type: 'facility', tagline: 'Test tagline 2', date_initiated: 'Sun, 24 Oct 2004 00:00:00 UTC +00:00', summary: 'This is another best practice.')
    PracticeOriginFacility.create!(practice: @practice2, facility_type:0, facility_id: '687HA')

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

  def update_practice_introduction(practice)
    login_as(@admin, :scope => :user, :run_callbacks => false)
    visit practice_introduction_path(practice)
    find("#initiating_facility_type_department").sibling('label').click
    select('VBA', :from => 'editor_department_select')
    select('Alabama', :from => 'editor_office_state_select')
    select('Montgomery Regional Office', :from => 'editor_office_select')
    fill_in('practice_summary', with: 'This is the most super practice ever made')
    fill_in('Tagline (required field)', with: 'practice tagline')
    select('October', :from => 'editor_date_initiated_month')
    fill_in('Year', with: '1970')
    find("#maturity_level_replicate").sibling('label').click
    find('#practice-editor-save-button').click
  end

  def publish_practice(practice)
    update_practice_introduction(practice)
    visit(practice_adoptions_path(practice))
    find('button[aria-controls="a0"]').click
    find('label[for="status_in_progress"').click
    select('Alaska', :from => 'editor_state_select')
    select('Anchorage VA Medical Center', :from => 'editor_facility_select')
    find('#adoption_form_submit').click
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
      expect(page).to have_content('Palo Alto VA Medical Center-Menlo Park (Palo Alto-Menlo Park)')
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

    it 'should be able to search based on practice maturity level' do
      @practice.update(published: true, approved: true, maturity_level: 'replicate')

      visit '/search'

      fill_in('dm-practice-search-field', with: 'replicate')
      find('#dm-practice-search-button').click

      expect(page).to have_content(@practice.name)
      expect(page).to have_content(@practice.maturity_level)
      expect(page).to have_content('1 result for replicate')
    end
  end

  describe 'Cache' do
    it 'Should be reset if certain practice attributes have been updated' do
      add_search_to_cache

      expect(cache_keys).to include("searchable_practices")

      update_practice_introduction(@practice)

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
      sleep 1
      expect(cache_keys).to include("searchable_practices")
      expect(Practice.searchable_practices.last.name).to eq(latest_practice.name)
      visit '/search?=newest'
      expect(page).to have_content('1 result for newest')
      expect(page).to have_content(latest_practice.name)
    end
  end
end
