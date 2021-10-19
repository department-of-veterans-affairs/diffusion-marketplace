require 'rails_helper'

describe 'VA facility pages', type: :feature do
  before do
    @visn = Visn.create!(name: 'Test VISN', number: 2)
    @visn_3 = Visn.create!(name: 'VISN 3', number: 3)

    @facility_1 = VaFacility.create!(
      visn: @visn, station_number: "421",
      official_station_name: "A Test name",
      common_name: "A first facility Test Common Name",
      fy17_parent_station_complexity_level: "1a-High Complexity",
      latitude: "44.03409934",
      longitude: "-70.70545322",
      rurality: "U",
      street_address: "1 Test Ave",
      street_address_city: "Las Vegas",
      street_address_state: "NV",
      station_phone_number: '207-623-8411',
      street_address_zip_code: "11111",
      slug: "a-first-facility-test-common-name",
      station_number_suffix_reservation_effective_date: "05/23/1995",
      mailing_address_city: "Las Vegas"
    )
    @facility_2 = VaFacility.create!(
      visn: @visn,
      sta3n: "400",
      station_number: "400",
      official_station_name: "B Test name",
      common_name: "B Test Common Name",
      classification: "VA Medical Center (VAMC)",
      classification_status: "Firm",
      mobile: "No",
      parent_station_number: "414",
      official_parent_station_name: "Test station",
      fy17_parent_station_complexity_level: "1b-High Complexity",
    )
    @facility_3 = VaFacility.create!(
      visn: @visn_3,
      sta3n: "401",
      station_number: "401",
      official_station_name: "C Test name",
      common_name: "C Test Common Name",
      classification: "VA Medical Center (VAMC)",
      classification_status: "Firm",
      mobile: "No",
      parent_station_number: "414",
      official_parent_station_name: "Test station",
      fy17_parent_station_complexity_level: "1c-High Complexity",
    )

    @admin = User.create!(email: 'sandy.cheeks@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(User::USER_ROLES[1].to_sym)
  end

  describe 'index page' do
    it 'should be there' do
      visit '/facilities'
      expect(page).to have_selector('.dm-loading-spinner', visible: false)
      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_css('#dm-va-facilities-directory-table')
      expect(page).to have_current_path(va_facilities_path)
      expect(page).to have_content("Facilities")
      expect(page).to have_content("Looking for a full list of VISNs?")
      expect(page).to have_content("Displaying 3 results:")
      within(:css, '#dm-va-facilities-directory-table') do
        expect(page).to have_content("Facility")
        expect(page).to have_content("State")
        expect(page).to have_content("VISN")
        expect(page).to have_content("Complexity")
        expect(page).to have_content("Created")
        expect(page).to have_content("Adopted")
        expect(page).to have_content("A Test name")
        expect(page).to have_content('C Test name')
        expect(page).to have_content("NV")
      end
      expect(find_all('.usa-select').first.value).to eq ''
    end

    context 'index page filters' do
      it 'should filter by complexity type and visn' do
        visit '/facilities'
        expect(page).to have_selector('.dm-loading-spinner', visible: false)
        # filter by complexity
        select "1a-High Complexity", :from => "facility_type_select"
        section = find(:css, '#dm-va-facilities-directory-table')
        expect(section).to have_content('A Test name')
        expect(section).to have_no_content('1B')
        expect(section).to have_no_content('1C')
        # filter by complexity and visn - no results
        select "1b-High Complexity", :from => "facility_type_select"
        select "3 - VISN 3", :from => "facility_visn_select"
        expect(page).to have_content('There are currently no matches for your search on the Marketplace')
        # filter by visn - results
        select "- Select -", :from => "facility_type_select"
        section = find(:css, '#dm-va-facilities-directory-table')
        expect(section).to have_content('C Test name')
        expect(section).to have_no_content('B Test name')
        expect(section).to have_no_content('A Test name')
        # filter by complexity and visn - results
        select "2 - Test VISN", :from => "facility_visn_select"
        expect(section).to have_content('B Test name')
        expect(section).to have_content('A Test name')
        expect(section).to have_no_content('C Test mame')
        select "1a-High Complexity", :from => "facility_type_select"
        expect(section).to have_content('A Test name')
        expect(section).to have_no_content('B Test name')
        expect(section).to have_no_content('C Test name')
      end

      it 'should filter by facility' do
        visit '/facilities'
        expect(page).to have_selector('.dm-loading-spinner', visible: false)
        section = find(:css, '#dm-va-facilities-directory-table')
        find('#facility_facilities_combo_box').click
        find_all('.usa-combo-box__list-option').first.click
        expect(section).to have_content('A Test name')
        expect(section).to have_no_content('B Test name')
        expect(section).to have_no_content('C Test name')

        find('.usa-combo-box__clear-input').click
        expect(section).to have_content('A Test name')
        expect(section).to have_content('B Test name')
        expect(section).to have_content('C Test name')
      end
    end
  end

  describe 'show page' do
    before do
      cat_1 = Category.create!(name: 'COVID', related_terms: ["COVID-19", "COVID 19", "Coronavirus"] )
      cat_2 = Category.create(name: 'Telehealth')
      cat_3 = Category.create!(name: 'Other')
      cat_4 = Category.create!(name: 'Other Subcategory', is_other: true)
      cat_5 = Category.create!(name: 'Main Level Cat')

      user = User.create!(email: 'test@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
      practice_names = ['Cards for Memory', 'BIONE', 'GERIVETZ', 'Gerofit', 'Pink Gloves Program', 'REVAMP', 'Telemedicine', 'Different practice']
      @practices = []
      practice_names.each do |name|
        @practices.push(Practice.create!(name: name, approved: true, published: true, enabled: true, initiating_facility_type: "facility", tagline: "Tagline for #{name}", support_network_email: 'test@test.com', user: user, summary: "Summary for #{name}", overview_problem: "Overview problem for #{name}", overview_solution: "Overview solution for #{name}", overview_results: "Overview results for #{name}", maturity_level: 0 ))
      end

      pr_1 = Practice.create!(name: 'Unpublished practice', approved: false, published: false, user: user)
      CategoryPractice.create!(practice: pr_1, category: cat_5)

      @facility_4 = VaFacility.create!(
        visn: @visn,
        sta3n: "402",
        station_number: "402",
        official_station_name: "D Test name",
        common_name: "D Test Common Name",
        classification: "VA Medical Center (VAMC)",
        classification_status: "Firm",
        mobile: "No",
        parent_station_number: "414",
        official_parent_station_name: "Test station",
        fy17_parent_station_complexity_level: "1c-High Complexity",
      )

      @practices.each_with_index do |pr, index|
        PracticeOriginFacility.create!(practice: pr, facility_type: 0, va_facility: @facility_1)
        if pr.name == 'Different practice'
          CategoryPractice.create!(practice: pr, category: cat_3)
          CategoryPractice.create!(practice: pr, category: cat_4)
        elsif index < 3
          CategoryPractice.create!(practice: pr, category: cat_1)
        elsif index >= 3
          CategoryPractice.create!(practice: pr, category: cat_2)
          CategoryPractice.create!(practice: pr, category: cat_4)
          PracticeOriginFacility.create!(practice: pr, facility_type: 0, va_facility: @facility_4)
        end
      end

      dh_1 = DiffusionHistory.create!(practice_id: @practices[4].id, va_facility: @facility_2)
      DiffusionHistoryStatus.create!(diffusion_history_id: dh_1.id, status: 'Completed')
      dh_2 = DiffusionHistory.create!(practice_id: @practices[4].id, va_facility: @facility_4)
      DiffusionHistoryStatus.create!(diffusion_history_id: dh_2.id, status: 'Completed')
      dh_3 = DiffusionHistory.create!(practice_id: @practices[3].id, va_facility: @facility_2)
      DiffusionHistoryStatus.create!(diffusion_history_id: dh_3.id, status: 'Completed')
      dh_4 = DiffusionHistory.create!(practice_id: @practices[6].id, va_facility: @facility_2)
      DiffusionHistoryStatus.create!(diffusion_history_id: dh_4.id, status: 'Completed')
      dh_5 = DiffusionHistory.create!(practice_id: @practices[0].id, va_facility: @facility_4)
      DiffusionHistoryStatus.create!(diffusion_history_id: dh_5.id, status: 'Completed')
      dh_7 = DiffusionHistory.create!(practice_id: @practices[4].id, va_facility: @facility_1)
      DiffusionHistoryStatus.create!(diffusion_history_id: dh_7.id, status: 'Completed')
      dh_8 = DiffusionHistory.create!(practice_id: @practices[3].id, va_facility: @facility_1)
      DiffusionHistoryStatus.create!(diffusion_history_id: dh_8.id, status: 'Completed')
      dh_9 = DiffusionHistory.create!(practice_id: @practices[2].id, va_facility: @facility_1)
      DiffusionHistoryStatus.create!(diffusion_history_id: dh_9.id, status: 'Completed')
    end

    def login_and_visit_facility_page
      login_as(@admin, :scope => :user, :run_callbacks => false)
      visit va_facility_path(@facility_1)
    end

    def check_search_results_as_guest_user(container_selector)
      # Check the results for a VA-only practice as a guest user
      visit va_facility_path(@facility_1)
      expect(page).to_not have_selector(container_selector)

      # login as an admin and set the 'is_public' flag for the same practice to true
      login_as(@admin, :scope => :user, :run_callbacks => false)
      visit '/admin/practices'
      all('.toggle-practice-privacy-link')[5].click
      expect(page).to have_content("\"Gerofit\" is now a public-facing innovation")

      # logout and check the results again as a guest user
      logout
      visit va_facility_path(@facility_1)

      within(:css, container_selector) do
        expect(page).to have_content('1 result')
        expect(page).to have_content('Gerofit')
        expect(page).to_not have_content('There are currently no matches for your search on the Marketplace.')
      end
    end

    it 'should be there if the VA facility common name (friendly id) or id exists in the DB' do
      login_and_visit_facility_page
      visit '/facilities/a-first-facility-test-common-name'
      expect(page).to have_selector('.dm-loading-spinner', visible: false)
      expect(page).to have_current_path(va_facility_path(@facility_1))
    end

    context 'when searching for adopted innovations' do
      it 'should only display search results for practices that are public-facing if the user is a guest' do
        check_search_results_as_guest_user('#dm-facility-adopted-practice-search')
      end

      it 'should display default content' do
        login_and_visit_facility_page
        within(:css, '#dm-facility-adopted-practice-search') do
          expect(page).to have_content("Innovations adopted at this facility")
          find('#facility_category_select_adoptions').click
          within(:css, '#facility_category_select_adoptions--list') do
            expect(page).to have_content('COVID')
            expect(page).to have_content('Telehealth')
            expect(page).to have_no_content('Other Subcategory')
          end
          expect(find(".facility_category_select_adoptions.usa-select", visible: false).value).to eq("")
          expect(find("#dm-adopted-practices-search-field").value).to eq("")
          expect(find("#practices_adopted_at_facility_count").text).to eq("3 results:")
          expect(page).to have_content('3 results')
          expect(page).to have_content('GERIVETZ')
          expect(page).to have_text('Gerofit')
          expect(page).to have_text('Pink Gloves Program')
        end
      end

      it 'should filter by categories' do
        login_and_visit_facility_page
        within(:css, '#dm-facility-adopted-practice-search') do
          find('#facility_category_select_adoptions').click
          find_all('.usa-combo-box__list-option').first.click
          expect(page).to have_content('GERIVETZ')
          expect(page).to have_content('1 result:')
        end
      end

      it 'should allow search for innovation origin facility and adopting facility' do
        login_and_visit_facility_page
        within(:css, '#dm-facility-adopted-practice-search') do
          fill_in('dm-adopted-practices-search-field', with: ' d test name')
          find('#dm-adopted-practices-search-button').click
          expect(page).to have_content('2 results:')
          expect(page).to have_text('Gerofit')
          expect(page).to have_text('Pink Gloves Program')
        end
      end
    end

    context 'when searching for created practices' do
      it 'should only display search results for practices that are public-facing if the user is a guest' do
        check_search_results_as_guest_user('.dm-facility-created-practice-search')
      end

      it 'should display the correct default content' do
        login_and_visit_facility_page
        within(:css, '.dm-facility-created-practice-search') do
          find('#dm-created-practice-categories').click
          within(:css, '#dm-created-practice-categories--list') do
            expect(page).to have_content('COVID')
            expect(page).to have_content('Telehealth')
            expect(page).to have_no_content('Other')
            expect(page).to have_no_content('Other Subcategory')
            expect(page).to have_no_content('Main Level Cat')
          end
          expect(find(".dm-created-practice-categories.usa-select", visible: false).value).to eq("")
          expect(find("#dm-created-practice-search-field").value).to eq("")
          expect(find(".dm-created-practice-results-count").text).to eq("8 results:")
          expect(find("#dm-created-practices-sort-option").value).to eq("a_to_z")
          # should see 3 sort filters
          within(:css, "#dm-created-practices-sort-option") do
            expect(page).to have_content('Sort by A to Z')
            expect(page).to have_content('Sort by most adopted innovations')
            expect(page).to have_content('Sort by most recently added')
          end
          expect(page).to have_css('.dm-load-more-created-practices-btn')
          expect(find_all('.dm-practice-title')[0]).to have_text('BIONE')
          expect(find_all('.dm-practice-title')[1]).to have_text('Cards for Memory')
          expect(find_all('.dm-practice-title').last).to have_text('Different practice')
          expect(page).to have_css('.dm-practice-card', count: 3)
          find('.dm-load-more-created-practices-btn').click
          expect(page).to have_css('.dm-load-more-created-practices-btn')
          expect(page).to have_css('.dm-practice-card', count: 6)
          expect(find_all('.dm-practice-title')[3]).to have_text('GERIVETZ')
          expect(find_all('.dm-practice-title')[4]).to have_text('Gerofit')
          expect(find_all('.dm-practice-title')[5]).to have_text('Pink Gloves Program')
          find('.dm-load-more-created-practices-btn').click
          expect(page).to have_css('.dm-practice-card', count: 8)
          expect(find_all('.dm-practice-title')[6]).to have_text('REVAMP')
          expect(find_all('.dm-practice-title')[7]).to have_text('Telemedicine')
          expect(page).to have_no_css('.dm-load-more-created-practices-btn')
        end
      end

      it 'should sort the content by most adopted innovations' do
        login_and_visit_facility_page
        within(:css, '.dm-facility-created-practice-search') do
          expect(page).to have_content('8 results')
          select('Sort by most adopted innovations', from: 'created-practices-sort-option')
          expect(page).to have_css('.dm-load-more-created-practices-btn')
          expect(find_all('.dm-practice-title')[0]).to have_text('Pink Gloves Program')
          expect(find_all('.dm-practice-title')[1]).to have_text('Gerofit')
          expect(find_all('.dm-practice-title').last).to have_text('Cards for Memory')
          expect(page).to have_css('.dm-practice-card', count: 3)
          find('.dm-load-more-created-practices-btn').click
          expect(page).to have_css('.dm-practice-card', count: 6)
          expect(find_all('.dm-practice-title')[3]).to have_text('GERIVETZ')
          expect(find_all('.dm-practice-title')[4]).to have_text('Telemedicine')
          expect(find_all('.dm-practice-title')[5]).to have_text('BIONE')
          find('.dm-load-more-created-practices-btn').click
          expect(page).to have_css('.dm-practice-card', count: 8)
          expect(find_all('.dm-practice-title')[6]).to have_text('Different practice')
          expect(find_all('.dm-practice-title').last).to have_text('REVAMP')
          expect(page).to have_no_css('.dm-load-more-created-practices-btn')
        end
      end

      it 'should sort the content by most recently added' do
        login_and_visit_facility_page
        within(:css, '.dm-facility-created-practice-search') do
          expect(page).to have_content('8 results')
          select('Sort by most recently added', from: 'created-practices-sort-option')
          expect(page).to have_css('.dm-load-more-created-practices-btn')
          expect(find_all('.dm-practice-title')[0]).to have_text('Different practice')
          expect(find_all('.dm-practice-title')[1]).to have_text('Telemedicine')
          expect(find_all('.dm-practice-title').last).to have_text('REVAMP')
          expect(page).to have_css('.dm-practice-card', count: 3)
          find('.dm-load-more-created-practices-btn').click
          expect(page).to have_css('.dm-practice-card', count: 6)
          expect(find_all('.dm-practice-title')[3]).to have_text('Pink Gloves Program')
          expect(find_all('.dm-practice-title')[4]).to have_text('Gerofit')
          expect(find_all('.dm-practice-title')[5]).to have_text('GERIVETZ')
          find('.dm-load-more-created-practices-btn').click
          expect(page).to have_css('.dm-practice-card', count: 8)
          expect(find_all('.dm-practice-title')[6]).to have_text('BIONE')
          expect(find_all('.dm-practice-title').last).to have_text('Cards for Memory')
          expect(page).to have_no_css('.dm-load-more-created-practices-btn')
        end
      end

      it 'should filter by categories and allow for sorting' do
        login_and_visit_facility_page
        expect(page).to have_content('8 results')
        within(:css, '.dm-facility-created-practice-search') do
          find('#dm-created-practice-categories').click
          find_all('.usa-combo-box__list-option').first.click
          expect(page).to have_content('3 results')
          expect(page).to have_content('Cards for Memory')
          expect(page).to have_content('BIONE')
          expect(page).to have_content('GERIVETZ')
        end
      end

      it 'should allow search for innovation info' do
        login_and_visit_facility_page
        within(:css, '.dm-facility-created-practice-search') do
          fill_in('dm-created-practice-search-field', with: 'Cards')
          find('#dm-created-practice-search-button').click
          expect(page).to have_content('1 result')
          expect(page).to have_content('Cards for Memory')
          fill_in('dm-created-practice-search-field', with: 'tagline for BIONE')
          find('#dm-created-practice-search-button').click
          expect(page).to have_content('1 result')
          expect(page).to have_content('BIONE')
          fill_in('dm-created-practice-search-field', with: 'summary for Telemedicine')
          find('#dm-created-practice-search-button').click
          expect(page).to have_content('1 result')
          expect(page).to have_content('Telemedicine')
          fill_in('dm-created-practice-search-field', with: 'overview problem for GERIVETZ')
          find('#dm-created-practice-search-button').click
          expect(page).to have_content('1 result')
          expect(page).to have_content('GERIVETZ')
          fill_in('dm-created-practice-search-field', with: 'overview solution for Pink gloves ProGram')
          find('#dm-created-practice-search-button').click
          expect(page).to have_content('1 result')
          expect(page).to have_content('Pink Gloves Program')
          fill_in('dm-created-practice-search-field', with: 'Overview Results for REVAmp')
          find('#dm-created-practice-search-button').click
          expect(page).to have_content('1 result')
          expect(page).to have_content('REVAMP')
          fill_in('dm-created-practice-search-field', with: 'emerging')
          find('#dm-created-practice-search-button').click
          expect(page).to have_content('8 results')
          expect(page).to have_css('.dm-load-more-created-practices-btn')
        end
      end

      it 'should allow search for innovation origin facility and adopting facility' do
        login_and_visit_facility_page
        within(:css, '.dm-facility-created-practice-search') do
          expect(page).to have_content('8 results')
          fill_in('dm-created-practice-search-field', with: 'd test name')
          find('#dm-created-practice-search-button').click
          expect(page).to have_css('.dm-created-practice-results-count')
          expect(page).to have_content('5 results')
          expect(page).to have_content('Cards for Memory')
          expect(page).to have_content('Gerofit')
          expect(page).to have_content('Pink Gloves Program')
          find('.dm-load-more-created-practices-btn').click
          expect(page).to have_css('.dm-practice-card', count: 5)
          expect(page).to have_content('REVAMP')
          expect(page).to have_content('Telemedicine')
        end
      end

      it 'should allow search for categories and related terms' do
        login_and_visit_facility_page
        expect(page).to have_content('8 results')
        within(:css, '.dm-facility-created-practice-search') do
          fill_in('dm-created-practice-search-field', with: 'coronavirus')
          find('#dm-created-practice-search-button').click
          expect(page).to have_content('3 results')
          expect(page).to have_content('Cards for Memory')
          expect(page).to have_content('BIONE')
          expect(page).to have_content('GERIVETZ')
          fill_in('dm-created-practice-search-field', with: 'telehealth')
          find('#dm-created-practice-search-button').click
          expect(page).to have_content('4 results')
          expect(page).to have_content('Gerofit')
          expect(page).to have_content('Pink Gloves Program')
          expect(page).to have_content('REVAMP')
          expect(page).to have_css('.dm-load-more-created-practices-btn')
        end
      end
    end
  end
end
