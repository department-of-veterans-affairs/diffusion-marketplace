require 'rails_helper'
require 'rake'

describe 'Search', type: :feature do
  def user_login
    login_as(@user, :scope => :user, :run_callbacks => false)
  end

  before do
    visn_1 = Visn.find_or_create_by!(name: "VA New England Healthcare System", number: 1)
    visn_2 = Visn.find_or_create_by!(name: "New York/New Jersey VA Health Care Network", number: 2)
    Visn.find_or_create_by!(name: "VA Healthcare - VISN 4", number: 4)
    Visn.find_or_create_by!(name: "VA Capitol Health Care Network", number: 5)
    visn_7 = Visn.find_or_create_by!(name: "VA Southeast Network", number: 7)
    visn_10 = Visn.find_or_create_by!(name: "VA Healthcare System", number: 10)
    visn_16 = Visn.find_or_create_by!(name: "South Central VA Health Care Network", number: 16)
    visn_19 = Visn.find_or_create_by!(name: "Rocky Mountain Network", number: 19)
    visn_20 = Visn.find_or_create_by!(name: "Northwest Network", number: 20)
    visn_21 = Visn.find_or_create_by!(name: "Sierra Pacific Network", number: 21)
    visn_22 = Visn.find_or_create_by!(name: "Desert Pacific Healthcare Network", number: 22)
    visn_23 = Visn.find_or_create_by!(name: "VA Midwest Health Care Network", number: 23)

    facility_1 = VaFacility.create!(visn: visn_1, station_number: "402", official_station_name: "Togus VA Medical Center", common_name: "Togus", street_address_state: "ME")
    facility_2 = VaFacility.create!(visn: visn_2, station_number: "528QK", official_station_name: "Saranac Lake VA Clinic", common_name: "Saranac Lake", street_address_state: "NY")
    facility_3 = VaFacility.create!(visn: visn_2, station_number: "561BY", official_station_name: "Newark VA Clinic", common_name: "Newark-New Jersey", street_address_state: "NJ")
    facility_4 = VaFacility.create!(visn: visn_2, station_number: "561BZ", official_station_name: "James J. Howard Veterans' Outpatient Clinic", common_name: "Brick", street_address_state: "NJ")
    facility_5 = VaFacility.create!(visn: visn_2, station_number: "528QH", official_station_name: "South Salina VA Clinic", common_name: "South Salina", street_address_state: "NY")
    facility_6 = VaFacility.create!(visn: visn_7, station_number: "544GG", official_station_name: "Spartanburg VA Clinic", common_name: "Spartanburg", street_address_state: "SC")
    facility_7 = VaFacility.create!(visn: visn_10, station_number: "539QD", official_station_name: "Norwood VA Clinic", common_name: "Norwood", street_address_state: "OH")
    facility_8 = VaFacility.create!(visn: visn_10, station_number: "538GC", official_station_name: "Marietta VA Clinic", common_name: "Marietta", street_address_state: "OH")
    facility_9 = VaFacility.create!(visn: visn_10, station_number: "541GB", official_station_name: "Lorain VA Clinic", common_name: "Lorain", street_address_state: "OH")
    facility_10 = VaFacility.create!(visn: visn_10, station_number: "541GH", official_station_name: "East Liverpool VA Clinic", common_name: "East Liverpool", street_address_state: "OH")
    facility_11 = VaFacility.create!(visn: visn_16, station_number: "520", official_station_name: "Biloxi VA Medical Center", common_name: "Biloxi", street_address_state: "MS")
    facility_12 = VaFacility.create!(visn: visn_19, station_number: "623GB", official_station_name: "Vinita VA Clinic", common_name: "Vinita", street_address_state: "OK")
    facility_13 = VaFacility.create!(visn: visn_20, station_number: "687HA", official_station_name: "Yakima VA Clinic", common_name: "Yakima", street_address_state: "WA")
    facility_14 = VaFacility.create!(visn: visn_21, station_number: "640A0", official_station_name: "Palo Alto VA Medical Center-Menlo Park", common_name: "Palo Alto-Menlo Park", street_address_state: "CA")
    facility_15 = VaFacility.create!(visn: visn_22, station_number: "649GA", official_station_name: "Kingman VA Clinic", common_name: "Kingman", street_address_state: "AZ")
    facility_16 = VaFacility.create!(visn: visn_23, station_number: "438GD", official_station_name: "Aberdeen VA Clinic", common_name: "Aberdeen", street_address_state: "SD")

    @user = User.create!(email: 'spongebob.squarepants@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @user2 = User.create!(email: 'patrick.star@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin = User.create!(email: 'sandy.cheeks@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @approver = User.create!(email: 'squidward.tentacles@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(User::USER_ROLES[1].to_sym)
    @approver.add_role(User::USER_ROLES[0].to_sym)
    @practice = Practice.create!(name: 'The Best Practice Ever!', initiating_facility_type: 'facility', tagline: 'Test tagline', date_initiated: 'Sun, 05 Feb 1992 00:00:00 UTC +00:00', summary: 'This is the best practice ever.', overview_problem: 'overview problem foobar', published: true, approved: true, enabled: true, hidden: false, user: @user2)
    PracticeOriginFacility.create!(practice: @practice, facility_type: 0, va_facility: facility_14)
    @practice2 = Practice.create!(name: 'Another Best Practice', initiating_facility_type: 'facility', tagline: 'Test tagline 2', date_initiated: 'Sun, 24 Oct 2004 00:00:00 UTC +00:00', summary: 'This is another best practice.', user: @user2)
    PracticeOriginFacility.create!(practice: @practice2, facility_type: 0, va_facility: facility_13)
    @practice3 = Practice.create!(name: 'Some Cool Practice', initiating_facility_type: 'facility', tagline: 'Test tagline 3', date_initiated: 'Mon, 08 Mar 1994 00:00:00 UTC +00:00', summary: 'This is the second best practice ever.', overview_solution: 'overview solution fizzbuzz', published: true, approved: true, enabled: true, hidden: false, user: @user2)
    PracticeOriginFacility.create!(practice: @practice3, facility_type: 0, va_facility: facility_1)
    @practice4 = Practice.create!(name: 'A Fantastic Practice', initiating_facility_type: 'visn', initiating_facility: '1', tagline: 'Test tagline 4', date_initiated: 'Wed, 15 May 2008 00:00:00 UTC +00:00', summary: 'This is the third best practice ever.', published: true, approved: true, enabled: true, hidden: false, user: @user2)
    @practice5 = Practice.create!(name: 'Random Practice', initiating_facility_type: 'facility', tagline: 'Test tagline 5', date_initiated: 'Fri, 27 Feb 1990 00:00:00 UTC +00:00', summary: 'This is the fourth best practice ever.', overview_results: 'overview results mixmax', published: true, approved: true, enabled: true, hidden: false, user: @user2)
    PracticeOriginFacility.create!(practice: @practice5, facility_type: 0, va_facility: facility_1)
    @practice6 = Practice.create!(name: 'One Practice to Rule Them All', initiating_facility_type: 'visn', initiating_facility: '1', tagline: 'Test tagline 6', date_initiated: 'Sun, 21 Oct 2001 00:00:00 UTC +00:00', summary: 'This is the fifth best practice ever.', published: true, approved: true, enabled: true, hidden: false, user: @user2)
    @practice7 = Practice.create!(name: 'Practice of the Ages', initiating_facility_type: 'facility', tagline: 'Test tagline 7', date_initiated: 'Mon, 26 Feb 1986 00:00:00 UTC +00:00', summary: 'This is the sixth best practice ever.', published: true, approved: true, enabled: true, hidden: false, user: @user2)
    PracticeOriginFacility.create!(practice: @practice7, facility_type: 0, va_facility: facility_7)
    PracticeOriginFacility.create!(practice: @practice7, facility_type: 0, va_facility: facility_8)
    @practice8 = Practice.create!(name: 'An Unforgettable Practice', initiating_facility_type: 'facility', tagline: 'Test tagline 8', date_initiated: 'Sat, 11 Jun 1997 00:00:00 UTC +00:00', summary: 'This is the seventh best practice ever.', published: true, approved: true, enabled: true, hidden: false, user: @user2)
    PracticeOriginFacility.create!(practice: @practice8, facility_type: 0, va_facility: facility_9)
    @practice9 = Practice.create!(name: 'One Amazing Practice', initiating_facility_type: 'visn', initiating_facility: '3', tagline: 'Test tagline 9', date_initiated: 'Fri, 09 Feb 1996 00:00:00 UTC +00:00', summary: 'This is the eighth best practice ever.', published: true, approved: true, enabled: true, hidden: false, user: @user2)
    @practice10 = Practice.create!(name: 'The Most Efficient Practice', initiating_facility_type: 'visn', initiating_facility: '4', tagline: 'Test tagline 10', date_initiated: 'Wed, 21 Aug 2002 00:00:00 UTC +00:00', summary: 'This is the ninth best practice ever.', published: true, approved: true, enabled: true, hidden: false, user: @user2)
    @practice11 = Practice.create!(name: 'A Glorious Practice', initiating_facility_type: 'facility', tagline: 'Test tagline 11', date_initiated: 'Sat, 06 Feb 1992 00:00:00 UTC +00:00', summary: 'This is the tenth best practice ever.', published: true, approved: true, enabled: true, hidden: false, user: @user2)
    PracticeOriginFacility.create!(practice: @practice11, facility_type: 0, va_facility: facility_10)
    @practice12 = Practice.create!(name: 'The Most Magnificent Practice', initiating_facility_type: 'facility', tagline: 'Test tagline 12', date_initiated: 'Sun, 27 Jan 2010 00:00:00 UTC +00:00', summary: 'This is the eleventh best practice ever.', published: true, approved: true, enabled: true, hidden: false, user: @user2)
    PracticeOriginFacility.create!(practice: @practice12, facility_type: 0, va_facility: facility_12)
    @practice13 = Practice.create!(name: 'The Champion of Practices', initiating_facility_type: 'facility', tagline: 'Test tagline 13', date_initiated: 'Sun, 17 Nov 1991 00:00:00 UTC +00:00', summary: 'This is the twelfth best practice ever.', published: true, approved: true, enabled: true, hidden: false, user: @user2)
    PracticeOriginFacility.create!(practice: @practice13, facility_type: 0, va_facility: facility_2)
    @practice14 = Practice.create!(name: 'The Most Important Practice', initiating_facility_type: 'facility', tagline: 'Test tagline 14', date_initiated: 'Sun, 14 Nov 1999 00:00:00 UTC +00:00', summary: 'This is the thirteenth best practice ever.', published: true, approved: true, enabled: true, hidden: false, user: @user2, is_public: true)
    PracticeOriginFacility.create!(practice: @practice14, facility_type: 0, va_facility: facility_3)

    parent_cat_1 = Category.create!(name: 'Strategic')
    @cat_1 = Category.create!(name: 'COVID', is_other: false, parent_category: parent_cat_1)
    @cat_2 = Category.create!(name: 'Environmental Services', is_other: false, parent_category: parent_cat_1)
    @cat_3 = Category.create!(name: 'Follow-up Care', is_other: false, parent_category: parent_cat_1)
    @cat_4 = Category.create!(name: 'Pulmonary Care', is_other: false, parent_category: parent_cat_1)
    @cat_5 = Category.create!(name: 'Telehealth', is_other: false, parent_category: parent_cat_1)
    CategoryPractice.create!(practice: @practice, category: @cat_1, created_at: Time.now)
    CategoryPractice.create!(practice: @practice, category: @cat_2, created_at: Time.now)
    CategoryPractice.create!(practice: @practice, category: @cat_5, created_at: Time.now)
    CategoryPractice.create!(practice: @practice3, category: @cat_1, created_at: Time.now)
    CategoryPractice.create!(practice: @practice3, category: @cat_2, created_at: Time.now)
    CategoryPractice.create!(practice: @practice4, category: @cat_2, created_at: Time.now)
    CategoryPractice.create!(practice: @practice4, category: @cat_3, created_at: Time.now)
    CategoryPractice.create!(practice: @practice5, category: @cat_1, created_at: Time.now)
    CategoryPractice.create!(practice: @practice5, category: @cat_3, created_at: Time.now)
    CategoryPractice.create!(practice: @practice6, category: @cat_1, created_at: Time.now)
    CategoryPractice.create!(practice: @practice7, category: @cat_4, created_at: Time.now)
    CategoryPractice.create!(practice: @practice12, category: @cat_1, created_at: Time.now)

    dh_1 = DiffusionHistory.create!(practice_id: @practice.id, va_facility: facility_16)
    DiffusionHistoryStatus.create!(diffusion_history_id: dh_1.id, status: 'Completed')
    dh_2 = DiffusionHistory.create!(practice_id: @practice.id, va_facility: facility_4)
    DiffusionHistoryStatus.create!(diffusion_history_id: dh_2.id, status: 'Completed')
    dh_3 = DiffusionHistory.create!(practice_id: @practice.id, va_facility: facility_11)
    DiffusionHistoryStatus.create!(diffusion_history_id: dh_3.id, status: 'Completed')
    dh_4 = DiffusionHistory.create!(practice_id: @practice3.id, va_facility: facility_16)
    DiffusionHistoryStatus.create!(diffusion_history_id: dh_4.id, status: 'Completed')
    dh_5 = DiffusionHistory.create!(practice_id: @practice3.id, va_facility: facility_15)
    DiffusionHistoryStatus.create!(diffusion_history_id: dh_5.id, status: 'Completed')
    dh_6 = DiffusionHistory.create!(practice_id: @practice6.id, va_facility: facility_6)
    DiffusionHistoryStatus.create!(diffusion_history_id: dh_6.id, status: 'Completed')
    dh_7 = DiffusionHistory.create!(practice_id: @practice10.id, va_facility: facility_5)
    DiffusionHistoryStatus.create!(diffusion_history_id: dh_7.id, status: 'Completed')
    partner_1 = PracticePartner.create!(name: 'Practice Partner 1', is_major: true)
    PracticePartnerPractice.create!(practice: @practice, practice_partner: partner_1)
    PracticePartnerPractice.create!(practice: @practice3, practice_partner: partner_1)
    partner_2 = PracticePartner.create!(name: 'Practice Partner 2', is_major: true)
    PracticePartnerPractice.create!(practice: @practice, practice_partner: partner_2)
    PracticePartnerPractice.create!(practice: @practice4, practice_partner: partner_2)
    partner_3 = PracticePartner.create!(name: 'Practice Partner 3', is_major: true)
    PracticePartnerPractice.create!(practice: @practice3, practice_partner: partner_3)
    partner_4 = PracticePartner.create!(name: 'Practice Partner 4')
    PracticePartnerPractice.create!(practice: @practice5, practice_partner: partner_4)
    user_login
  end

  def visit_search_page
    visit '/search'
  end

  def search
    find('#dm-practice-search-button').click
  end

  def toggle_filters_accordion
    find('.search-filters-accordion-button').click
  end

  def update_results
    click_button('Update results')
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
    find("label[for*='status_completed']").click
    find('#editor_facility_select').click
    find("#editor_facility_select--list--option-0").click
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

  def set_combobox_val(index, value)
    find_all('.usa-combo-box__input')[index].click
    find_all('.usa-combo-box__input')[index].set(value)
    find_all('.usa-combo-box__list-option').first.click
  end

  def select_category(label_class)
    find(label_class).click
  end

  def select_practice_partner(index)
    all('.practice-partner-search-checkbox-label')[index].click
  end

  describe 'initial page load' do
    it 'Should display all published/enabled/approved practices if the user navigates to the search page with no query' do
      visit_search_page
      expect(page).to have_content('Load more')
      click_button('Load more')
      expect(page).to have_content(@practice.name)
      expect(page).to have_content(@practice3.name)
      expect(page).to have_content(@practice4.name)
      expect(page).to have_content(@practice5.name)
      expect(page).to have_content(@practice6.name)
      expect(page).to have_content(@practice7.name)
      expect(page).to have_content(@practice8.name)
      expect(page).to have_content(@practice9.name)
      expect(page).to have_content(@practice10.name)
      expect(page).to have_content(@practice11.name)
      expect(page).to have_content(@practice12.name)
      expect(page).to have_content(@practice13.name)
      expect(page).to have_content(@practice14.name)
    end
  end

  describe 'results' do
    it 'should display all published/enabled/approved practices if the user clicks on the search button with no query or filters' do
      visit '/'
      find('#dm-navbar-search-desktop-button').click
      expect(page).to have_content('Load more')
      click_button('Load more')
      expect(page).to have_content(@practice.name)
      expect(page).to have_content(@practice3.name)
      expect(page).to have_content(@practice4.name)
      expect(page).to have_content(@practice5.name)
      expect(page).to have_content(@practice6.name)
      expect(page).to have_content(@practice7.name)
      expect(page).to have_content(@practice8.name)
      expect(page).to have_content(@practice9.name)
      expect(page).to have_content(@practice10.name)
      expect(page).to have_content(@practice11.name)
      expect(page).to have_content(@practice12.name)
      expect(page).to have_content(@practice13.name)
      expect(page).to have_content(@practice14.name)
    end

    it 'should display certain text if no matches are found' do
      visit_search_page
      toggle_filters_accordion
      fill_in('dm-practice-search-field', with: 'test')
      set_combobox_val(0, 'James J. Howard Veterans\' Outpatient Clinic')
      select_category('.cat-2-label')
      search
      expect(page).to_not have_content('results')
      expect(page).to have_content('There are currently no matches for your search on the Marketplace.')
    end

    it 'should only show approved and published practices' do
      visit_search_page
      expect(page).to be_accessible.according_to :wcag2a, :section508

      fill_in('dm-practice-search-field', with: 'Test')
      search

      expect(page).to be_accessible.according_to :wcag2a, :section508

      # do not show a practice that is not approved/published
      fill_in('dm-practice-search-field', with: 'practice')
      find('#dm-practice-search-button').click

      expect(page).to have_content('13 results')
      expect(page).to_not have_content(@practice2.name)

      # show practices that are approved/published
      @practice2.update(published: true, approved: true)
      visit_search_page
      fill_in('dm-practice-search-field', with: 'practice')
      search

      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_content('14 results')
      expect(page).to have_content(@practice2.name)
    end

    it 'should be able to search based on practice categories' do
      visit_search_page

      fill_in('dm-practice-search-field', with: 'Telehealth')
      find('#dm-practice-search-button').click

      expect(page).to have_content(@practice.name)
      expect(page).to have_content(@practice.initiating_facility)
      expect(page).to have_content('1 result')
    end

    it 'should be able to search based on practice categories related terms' do
      @cat_1.update(related_terms: ['Coronavirus'])

      visit_search_page

      fill_in('dm-practice-search-field', with: 'Coronavirus')
      find('#dm-practice-search-button').click

      expect(page).to have_content('5 results')
      expect(page).to have_content(@practice.name)
      expect(page).to have_content(@practice3.name)
      expect(page).to have_content(@practice5.name)
      expect(page).to have_content(@practice6.name)
      expect(page).to have_content(@practice12.name)
      expect(page).to have_content(@practice.initiating_facility)
    end

    it 'should be able to search based on practice maturity level' do
      @practice.update(maturity_level: 'replicate')

      visit_search_page

      fill_in('dm-practice-search-field', with: 'replicate')
      find('#dm-practice-search-button').click

      expect(page).to have_content(@practice.name)
      expect(page).to have_content('1 result')
    end

    it 'should be able to search based on originating facility name' do
      visit_search_page

      fill_in('dm-practice-search-field', with: 'Togus VA Medical Center')
      find('#dm-practice-search-button').click

      expect(page).to have_content('2 results')
      expect(page).to have_content(@practice3.name)
      expect(page).to have_content(@practice5.name)
    end

    it 'should be able to search based on overview problem, solution, and results' do
      visit_search_page
      fill_in('dm-practice-search-field', with: 'overview problem foobar')
      find('#dm-practice-search-button').click
      expect(page).to have_content('1 result')
      expect(page).to have_content(@practice.name)

      visit_search_page
      fill_in('dm-practice-search-field', with: 'overview solution fizzbuzz')
      find('#dm-practice-search-button').click
      expect(page).to have_content('1 result')
      expect(page).to have_content(@practice3.name)

      visit_search_page
      fill_in('dm-practice-search-field', with: 'overview results mixmax')
      find('#dm-practice-search-button').click
      expect(page).to have_content('1 result')
      expect(page).to have_content(@practice5.name)
    end

    it 'should be able to search based on practice partners' do
      visit_search_page
      fill_in('dm-practice-search-field', with: 'practice partner')
      find('#dm-practice-search-button').click
      expect(page).to have_content('4 results')
      expect(page).to have_content(@practice.name)
      expect(page).to have_content(@practice3.name)
      expect(page).to have_content(@practice4.name)
      expect(page).to have_content(@practice5.name)
    end

    it 'should only display search results for practices that are public-facing if the user is a guest' do
      # Try to search for an internal, VA-only practice as a guest user
      logout
      visit_search_page

      fill_in('dm-practice-search-field', with: 'important')
      search
      expect(page).to have_content('1 result')
      expect(page).to have_content('The Most Important Practice')

      fill_in('dm-practice-search-field', with: 'Rule')
      search
      expect(page).to_not have_content('results')
      expect(page).to_not have_content('One Practice to Rule Them All')
      expect(page).to have_content('There are currently no matches for your search on the Marketplace.')

      # login as an admin and set the 'is_public' flag for the same practice to true
      login_as(@admin, :scope => :user, :run_callbacks => false)
      visit '/admin/practices'
      all('.toggle-practice-privacy-link')[8].click
      expect(page).to have_content("\"One Practice to Rule Them All\" is now a public-facing innovation")

      # logout and search for the practice again as a guest user
      logout
      visit_search_page

      fill_in('dm-practice-search-field', with: 'Rule')
      search
      expect(page).to have_content('1 result')
      expect(page).to have_content('One Practice to Rule Them All')
      expect(page).to_not have_content('There are currently no matches for your search on the Marketplace.')
    end

    describe 'Filters' do
      it 'should collect practices that match ANY of the conditions if the user selects filters, but does not use the search input' do
        visit_search_page

        toggle_filters_accordion
        set_combobox_val(0, 'Norwood VA Clinic')
        select_category('.cat-2-label')
        select_category('.cat-5-label')
        select_practice_partner(0)
        update_results

        expect(page).to have_content('Filters (4)')
        expect(page).to have_content('6 results')
        expect(page).to have_content(@practice.name)
        expect(page).to have_content(@practice3.name)
        expect(page).to have_content(@practice5.name)
        expect(page).to have_content(@practice7.name)
        expect(page).to have_content(@practice12.name)
      end

      it 'should select all subcategories when selecting the parent category' do
        visit_search_page
        toggle_filters_accordion
        select_category('.cat-all-strategic-label')
        expect(find("#cat-2-input", visible: false)).to be_checked
        expect(find("#cat-3-input", visible: false)).to be_checked
        expect(find("#cat-4-input", visible: false)).to be_checked
        expect(find("#cat-5-input", visible: false)).to be_checked
        expect(find("#cat-6-input", visible: false)).to be_checked
        update_results
        expect(page).to have_content('7 results')
        toggle_filters_accordion
        select_category('.cat-2-label')
        expect(find("#cat-all-strategic-input", visible: false)).to_not be_checked
        expect(find("#cat-2-input", visible: false)).to_not be_checked
        expect(find("#cat-3-input", visible: false)).to be_checked
        expect(find("#cat-4-input", visible: false)).to be_checked
        expect(find("#cat-5-input", visible: false)).to be_checked
        expect(find("#cat-6-input", visible: false)).to be_checked
        update_results
        expect(page).to have_content('5 results')
      end

      it 'should collect practices that match ALL of the conditions if the user selects filters AND uses the search input' do
        # Filter practices down to where there are two matches
        visit_search_page

        fill_in('dm-practice-search-field', with: 'practice')
        toggle_filters_accordion
        set_combobox_val(0, 'Togus VA Medical Center')
        select_category('.cat-2-label')
        search
        expect(page).to have_content('Filters (2)')
        expect(page).to have_content('2 results')
        expect(page).to have_content(@practice3.name)
        expect(page).to have_content(@practice5.name)

        # Now add the remaining to eliminate one of the last two practices
        toggle_filters_accordion
        set_combobox_val(1, 'Aberdeen VA Clinic')
        select_practice_partner(0)
        update_results

        expect(page).to have_content('Filters (4)')
        expect(page).to have_content('1 result')
        expect(page).to have_content(@practice3.name)
        expect(page).to_not have_content(@practice5.name)

        # Reset filters and select a VISN from the Originating Facility combo box
        toggle_filters_accordion
        click_button('Reset filters')
        set_combobox_val(0, 'VISN-1')
        update_results

        expect(page).to have_content('Filters (1)')
        expect(page).to have_content('4 results')
        expect(page).to have_content(@practice3.name)
        expect(page).to have_content(@practice4.name)
        expect(page).to have_content(@practice5.name)
        expect(page).to have_content(@practice6.name)

        toggle_filters_accordion
        select_category('.cat-4-label')
        update_results

        expect(page).to have_content('Filters (2)')
        expect(page).to have_content('2 results')
        expect(page).to have_content(@practice4.name)
        expect(page).to have_content(@practice5.name)

        # Reset filters and select a VISN from the Adopting Facility combo box
        toggle_filters_accordion
        click_button('Reset filters')
        set_combobox_val(1, 'VISN-7')
        update_results

        expect(page).to have_content('Filters (1)')
        expect(page).to have_content('1 result')
        expect(page).to have_content(@practice6.name)

        # Reset filters and select a practice partner from the major practice partner checkboxes
        toggle_filters_accordion
        click_button('Reset filters')
        select_practice_partner(0)
        update_results

        expect(page).to have_content('Filters (1)')
        expect(page).to have_content('2 results')
        expect(page).to have_content(@practice.name)
        expect(page).to have_content(@practice3.name)

        # select another practice partner to further filter down the results
        toggle_filters_accordion
        select_practice_partner(1)
        update_results

        expect(page).to have_content('Filters (2)')
        expect(page).to have_content('1 result')
        expect(page).to have_content(@practice.name)
      end

      it 'should only display checkboxes for major practice partners in the search filters' do
        visit_search_page
        toggle_filters_accordion
        expect(page).to have_css('.practice-partner-search-checkbox', visible: false, count: 3)
      end

      it 'should allow users to filter practices based on their practice partners' do
        visit_search_page
        toggle_filters_accordion
        select_practice_partner(0)
        search
        expect(page).to have_content('2 results:')
        expect(page).to have_content(@practice.name)
        expect(page).to have_content(@practice3.name)
      end

      describe 'Originating Facility Combo Box' do
        it 'should, when the user selects a VISN, collect practices that either have that VISN as their initiating_facility OR have a practice_origin_facility that belongs to that VISN' do
          visit_search_page

          toggle_filters_accordion
          set_combobox_val(0, 'VISN-1')
          update_results

          expect(page).to have_content('Filters (1)')
          expect(page).to have_content('4 results')
          expect(page).to have_content(@practice3.name)
          expect(page).to have_content(@practice3.name)
          expect(page).to have_content(@practice5.name)
          expect(page).to have_content(@practice6.name)
        end

        it 'should, when the user selects a facility, only collect practices that have a practice_origin_facility that matches the selected facility' do
          visit_search_page

          toggle_filters_accordion
          set_combobox_val(0, 'Vinita VA Clinic')
          update_results

          expect(page).to have_content('1 result')
          expect(page).to have_content(@practice12.name)
        end
      end

      describe 'Adopting Facility Combo Box' do
        it 'should, when the user selects a VISN, collect practices that have an adoption facility that belongs to that VISN' do
          visit_search_page

          toggle_filters_accordion
          set_combobox_val(1, 'VISN-23')
          update_results

          expect(page).to have_content('2 results')
          expect(page).to have_content(@practice.name)
          expect(page).to have_content(@practice3.name)
        end

        it 'should, when the user selects a facility, only collect practices that have an adopting facility that matches the selected facility' do
          visit_search_page

          toggle_filters_accordion
          set_combobox_val(0, 'Vinita VA Clinic')
          update_results

          expect(page).to have_content('1 result')
          expect(page).to have_content(@practice12.name)
        end
      end
    end

    describe 'Sorting' do
      it 'should sort the results based on the sort option chosen' do
        visit_search_page

        toggle_filters_accordion
        set_combobox_val(0, 'VISN-1')
        select_category('.cat-2-label')
        update_results

        # results should be sorted my most relevant(closest match) by default
        expect(page).to have_content('6 results')
        expect(first('h3.dm-practice-title').text).to eq(@practice6.name)

        toggle_filters_accordion
        select_category('.cat-3-label')
        select_category('.cat-4-label')
        update_results

        expect(page).to have_content('6 results')
        expect(first('h3.dm-practice-title').text).to_not eq(@practice6.name)
        expect(first('h3.dm-practice-title').text).to eq(@practice4.name)

        # choose 'A to Z' option
        select('Sort by A to Z', from: 'search_sort_option')
        expect(all('h3.dm-practice-title').first.text).to eq(@practice4.name)
        expect(all('h3.dm-practice-title')[1].text).to eq(@practice6.name)
        expect(all('h3.dm-practice-title')[2].text).to eq(@practice5.name)
        expect(all('h3.dm-practice-title')[3].text).to eq(@practice3.name)
        expect(all('h3.dm-practice-title')[4].text).to eq(@practice.name)
        expect(all('h3.dm-practice-title')[5].text).to eq(@practice12.name)

        # choose 'most adoptions' option
        select('Sort by most adopted innovations', from: 'search_sort_option')
        expect(all('h3.dm-practice-title').first.text).to eq(@practice.name)
        expect(all('h3.dm-practice-title')[1].text).to eq(@practice3.name)
        expect(all('h3.dm-practice-title')[2].text).to eq(@practice6.name)

        # choose 'most recently added' option
        select('Sort by most recently added', from: 'search_sort_option')
        expect(all('h3.dm-practice-title').first.text).to eq(@practice12.name)
        expect(all('h3.dm-practice-title')[1].text).to eq(@practice6.name)
        expect(all('h3.dm-practice-title')[2].text).to eq(@practice5.name)
        expect(all('h3.dm-practice-title')[3].text).to eq(@practice4.name)
        expect(all('h3.dm-practice-title')[4].text).to eq(@practice3.name)
        expect(all('h3.dm-practice-title')[5].text).to eq(@practice.name)
      end
    end

    describe 'Load more results feature' do
      it 'should only display the first twelve results, if there are more than twelve total results' do
        visit_search_page

        fill_in('dm-practice-search-field', with: 'practice')
        search

        expect(page).to have_content('13 results')
        expect(page).to have_selector('div.dm-practice-card', count: 12)

        # show the next set of 12 results
        click_button('Load more')
        expect(page).to have_selector('div.dm-practice-card', count: 13)
      end
    end

    describe 'Querying' do
      it 'should not create a query if the user does not enter text into the search input' do
        visit_search_page

        toggle_filters_accordion
        set_combobox_val(0, 'VISN-2')
        select_category('.cat-2-label')
        select_category('.cat-3-label')
        select_category('.cat-5-label')
        update_results

        expect(page.current_url.split('/').pop).to eq('search')
      end

      it 'should add a query if the user does enter text into the search input' do
        visit_search_page

        fill_in('dm-practice-search-field', with: 'test')
        search

        expect(page.current_url.split('/').pop).to eq('search?query=test')
      end

      it 'should, if there is no query and the user clicks on a practice card, add a search page breadcrumb that does not include a query' do
        visit_search_page

        toggle_filters_accordion
        select_category('.cat-2-label')
        update_results
        all('.dm-practice-link').first.click

        expect(page).to have_link('Search', href: '/search')
      end

      it 'should, if there is a query and the user clicks on a practice card, add a search page breadcrumb that includes the query' do
        visit_search_page

        fill_in('dm-practice-search-field', with: 'test')
        search
        all('.dm-practice-link').first.click

        expect(page).to have_link('Search', href: '/search?query=test')
      end
    end
  end

  describe 'Cache' do
    it 'Should be reset if certain practice attributes have been updated' do
      add_search_to_cache
      expect(cache_keys).to include("searchable_practices_json")
      update_practice_introduction(@practice)
      expect(page).to have_content("Innovation was successfully updated.")
      expect(page).to have_selector(".usa-alert", visible: true)
      expect(cache_keys).not_to include("searchable_practices_json")
    end

    it 'Should be reset if a new practice is created through the admin panel' do
      add_search_to_cache
      expect(cache_keys).to include("searchable_practices_json")
      login_as(@admin, :scope => :user, :run_callbacks => false)
      visit '/admin'
      click_link('Practices')
      click_link('New Practice')
      fill_in('Innovation name', with: 'The Newest Practice')
      fill_in('User email', with: 'practice_owner@va.gov')
      click_button('Create Practice')
      expect(page).to have_selector(".flash_notice", visible: true)
      expect(cache_keys).not_to include("searchable_practices_json")
    end
  end

  describe 'adding to the popular categories counts' do
    it 'should only create a \'Category selected\' Ahoy event if the user enters a keyword that matches the name of an existing category in the DB' do
      category_selected_event = Ahoy::Event.where(name: "Category selected")
      expect(category_selected_event.count).to eq(0)
      # start by sending an empty query
      visit_search_page
      search
      expect { search }.not_to change { category_selected_event.count }
      # now send in a close match
      fill_in('dm-practice-search-field', with: 'telehealt')
      search
      expect { search }.not_to change { category_selected_event.count }
      # now send in an exact match
      fill_in('dm-practice-search-field', with: 'telehealth')
      search
      expect { search }.to change { category_selected_event.count }.from(0).to(1)
    end
  end

  describe 'Mobile flow' do
    before do
        page.driver.browser.manage.window.resize_to(340, 580)
    end

    it 'should function appropriately' do
      visit_search_page

      click_button('Filters')
      click_button('Originating facility')
      set_combobox_val(0, 'Togus VA Medical Center')
      click_button('Adopting facility')
      set_combobox_val(1, 'VISN-2')
      click_button('Categories')
      select_category('.cat-5-label')
      update_results

      expect(page).to have_content('5 results')
      expect(page).to have_content(@practice.name)
      expect(page).to have_content(@practice3.name)
      expect(page).to have_content(@practice5.name)
      expect(page).to have_content(@practice7.name)
      expect(page).to have_content(@practice10.name)
    end
  end
end
