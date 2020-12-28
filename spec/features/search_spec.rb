require 'rails_helper'

describe 'Search', type: :feature do
  before do
    @user = User.create!(email: 'spongebob.squarepants@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @user2 = User.create!(email: 'patrick.star@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin = User.create!(email: 'sandy.cheeks@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @approver = User.create!(email: 'squidward.tentacles@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(User::USER_ROLES[1].to_sym)
    @approver.add_role(User::USER_ROLES[0].to_sym)
    @practice = Practice.create!(name: 'The Best Practice Ever!', initiating_facility_type: 'facility', tagline: 'Test tagline', date_initiated: 'Sun, 05 Feb 1992 00:00:00 UTC +00:00', summary: 'This is the best practice ever.', published: true, approved: true)
    PracticeOriginFacility.create!(practice: @practice, facility_type: 0, facility_id: '640A0')
    @practice2 = Practice.create!(name: 'Another Best Practice', initiating_facility_type: 'facility', tagline: 'Test tagline 2', date_initiated: 'Sun, 24 Oct 2004 00:00:00 UTC +00:00', summary: 'This is another best practice.')
    PracticeOriginFacility.create!(practice: @practice2, facility_type:0, facility_id: '687HA')
    @practice3 = Practice.create!(name: 'Some Cool Practice', initiating_facility_type: 'facility', tagline: 'Test tagline 3', date_initiated: 'Mon, 08 Mar 1994 00:00:00 UTC +00:00', summary: 'This is the second best practice ever.', published: true, approved: true)
    PracticeOriginFacility.create!(practice: @practice3, facility_type:0, facility_id: '402')
    @practice4 = Practice.create!(name: 'A Fantastic Practice', initiating_facility_type: 'visn', initiating_facility: '1', tagline: 'Test tagline 4', date_initiated: 'Wed, 15 May 2008 00:00:00 UTC +00:00', summary: 'This is the third best practice ever.', published: true, approved: true)
    @practice5 = Practice.create!(name: 'Random Practice', initiating_facility_type: 'facility', tagline: 'Test tagline 5', date_initiated: 'Fri, 27 Feb 1990 00:00:00 UTC +00:00', summary: 'This is the fourth best practice ever.', published: true, approved: true)
    PracticeOriginFacility.create!(practice: @practice5, facility_type:0, facility_id: '402')
    @practice6 = Practice.create!(name: 'One Practice to Rule Them All', initiating_facility_type: 'visn', initiating_facility: '1', tagline: 'Test tagline 6', date_initiated: 'Sun, 21 Oct 2001 00:00:00 UTC +00:00', summary: 'This is the fifth best practice ever.', published: true, approved: true)
    @practice7 = Practice.create!(name: 'Practice of the Ages', initiating_facility_type: 'facility', tagline: 'Test tagline 7', date_initiated: 'Mon, 26 Feb 1986 00:00:00 UTC +00:00', summary: 'This is the sixth best practice ever.', published: true, approved: true)
    PracticeOriginFacility.create!(practice: @practice7, facility_type:0, facility_id: '539QD')
    PracticeOriginFacility.create!(practice: @practice7, facility_type:0, facility_id: '538GC')
    @practice8 = Practice.create!(name: 'An Unforgettable Practice', initiating_facility_type: 'facility', tagline: 'Test tagline 8', date_initiated: 'Sat, 11 Jun 1997 00:00:00 UTC +00:00', summary: 'This is the seventh best practice ever.', published: true, approved: true)
    PracticeOriginFacility.create!(practice: @practice8, facility_type:0, facility_id: '541GB')
    @practice9 = Practice.create!(name: 'One Amazing Practice', initiating_facility_type: 'visn', initiating_facility: '3', tagline: 'Test tagline 9', date_initiated: 'Fri, 09 Feb 1996 00:00:00 UTC +00:00', summary: 'This is the eighth best practice ever.', published: true, approved: true)
    @practice10 = Practice.create!(name: 'The Most Efficient Practice', initiating_facility_type: 'visn', initiating_facility: '4', tagline: 'Test tagline 10', date_initiated: 'Wed, 21 Aug 2002 00:00:00 UTC +00:00', summary: 'This is the ninth best practice ever.', published: true, approved: true)
    @practice11 = Practice.create!(name: 'A Glorious Practice', initiating_facility_type: 'facility', tagline: 'Test tagline 11', date_initiated: 'Sat, 06 Feb 1992 00:00:00 UTC +00:00', summary: 'This is the tenth best practice ever.', published: true, approved: true)
    PracticeOriginFacility.create!(practice: @practice11, facility_type:0, facility_id: '541GH')
    @practice12 = Practice.create!(name: 'The Most Magnificent Practice', initiating_facility_type: 'facility', tagline: 'Test tagline 12', date_initiated: 'Sun, 27 Jan 2010 00:00:00 UTC +00:00', summary: 'This is the eleventh best practice ever.', published: true, approved: true)
    PracticeOriginFacility.create!(practice: @practice12, facility_type:0, facility_id: '623GB')
    @practice13 = Practice.create!(name: 'The Champion of Practices', initiating_facility_type: 'facility', tagline: 'Test tagline 13', date_initiated: 'Sun, 17 Nov 1991 00:00:00 UTC +00:00', summary: 'This is the twelfth best practice ever.', published: true, approved: true)
    PracticeOriginFacility.create!(practice: @practice12, facility_type:0, facility_id: '528QK')
    @practice14 = Practice.create!(name: 'The Most Important Practice', initiating_facility_type: 'facility', tagline: 'Test tagline 14', date_initiated: 'Sun, 14 Nov 1999 00:00:00 UTC +00:00', summary: 'This is the thirteenth best practice ever.', published: true, approved: true)
    PracticeOriginFacility.create!(practice: @practice12, facility_type:0, facility_id: '561BY')
    @cat_1 = Category.create!(name: 'COVID')
    @cat_2 = Category.create!(name: 'Environmental Services')
    @cat_3 = Category.create!(name: 'Follow-up Care')
    @cat_4 = Category.create!(name: 'Pulmonary Care')
    @cat_5 = Category.create!(name: 'Telehealth')
    CategoryPractice.create!(practice: @practice, category: @cat_1, created_at: Time.now)
    CategoryPractice.create!(practice: @practice, category: @cat_2, created_at: Time.now)
    CategoryPractice.create!(practice: @practice, category: @cat_5, created_at: Time.now)
    CategoryPractice.create!(practice: @practice2, category: @cat_1, created_at: Time.now)
    CategoryPractice.create!(practice: @practice2, category: @cat_2, created_at: Time.now)
    CategoryPractice.create!(practice: @practice4, category: @cat_3, created_at: Time.now)
    CategoryPractice.create!(practice: @practice5, category: @cat_3, created_at: Time.now)
    CategoryPractice.create!(practice: @practice7, category: @cat_4, created_at: Time.now)
    CategoryPractice.create!(practice: @practice12, category: @cat_1, created_at: Time.now)
    DiffusionHistory.create!(practice_id: @practice.id, facility_id: '438GD')
    DiffusionHistory.create!(practice_id: @practice3.id, facility_id: '438GD')
    DiffusionHistory.create!(practice_id: @practice6.id, facility_id: '544GG')
    DiffusionHistory.create!(practice_id: @practice10.id, facility_id: '528QH')
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
    find('#add_adoption_button').click
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
      user_login
      visit_search_page
      expect(page).to be_accessible.according_to :wcag2a, :section508

      fill_in('dm-practice-search-field', with: 'Test')
      search

      expect(page).to be_accessible.according_to :wcag2a, :section508

      # test facility data map for name, negative case
      expect(page).to have_content(@practice.name)
      expect(page).to have_content('Palo Alto VA Medical Center-Menlo Park (Palo Alto-Menlo…')
      expect(page).to have_content('13 results')

      # do not show a practice that is not approved/published
      fill_in('dm-practice-search-field', with: 'practice')
      find('#dm-practice-search-button').click

      expect(page).to have_content('13 results')

      # show practices that are approved/published
      @practice2.update(published: true, approved: true)
      visit_search_page
      fill_in('dm-practice-search-field', with: 'practice')
      search

      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_content(@practice.name)
      expect(page).to have_content(@practice2.name)
      expect(page).to have_content('14 results')

      # test facility data map for name, positive case
      expect(page).to have_content('Yakima VA Clinic')
    end

    it 'should be able to search based on practice categories' do
      visit '/search'

      fill_in('dm-practice-search-field', with: 'Telehealth')
      find('#dm-practice-search-button').click

      expect(page).to have_content(@practice.name)
      expect(page).to have_content(@practice.initiating_facility)
      expect(page).to have_content('1 result')
    end

    it 'should be able to search based on practice categories related terms' do
      @cat_1.update(related_terms: ['Coronavirus'])

      visit '/search'

      fill_in('dm-practice-search-field', with: 'Coronavirus')
      find('#dm-practice-search-button').click

      expect(page).to have_content(@practice.name)
      expect(page).to have_content(@practice12.name)
      expect(page).to have_content(@practice.initiating_facility)
      expect(page).to have_content('2 results')
    end

    it 'should be able to search based on practice maturity level' do
      @practice.update(maturity_level: 'replicate')

      visit '/search'

      fill_in('dm-practice-search-field', with: 'replicate')
      find('#dm-practice-search-button').click

      expect(page).to have_content(@practice.name)
      expect(page).to have_content('1 result')
    end
  end

  describe 'Cache' do
    it 'Should be reset if certain practice attributes have been updated' do
      add_search_to_cache

      expect(cache_keys).to include("searchable_practices_a_to_z")

      update_practice_introduction(@practice)
      sleep 2
      expect(cache_keys).not_to include("searchable_practices_a_to_z")
    end

    it 'Should be reset if a new practice is created through the admin panel' do
      add_search_to_cache

      expect(cache_keys).to include("searchable_practices_a_to_z")

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
      expect(cache_keys).not_to include("searchable_practices_a_to_z")
      # expect(Practice.searchable_practices.last.name).to eq(latest_practice.name)
      # visit '/search?=newest'
      # expect(page).to have_content('1 result for newest')
      # expect(page).to have_content(latest_practice.name)
    end
  end
end
