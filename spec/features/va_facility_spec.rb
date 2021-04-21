require 'rails_helper'

describe 'VA facility pages', type: :feature do
  before do
    @visn = Visn.create!(name: 'Test VISN', number: 2)
    @va_facility1 = VaFacility.create!(
        visn: @visn,
        sta3n: 421,
        station_number: 421,
        official_station_name: 'A Test name',
        common_name: 'A first facility Test Common Name',
        classification: 'VA Medical Center (VAMC)',
        classification_status: 'Firm',
        mobile: 'No',
        parent_station_number: 414,
        official_parent_station_name: 'Test station',
        fy17_parent_station_complexity_level: '1a-High Complexity',
        operational_status: 'A',
        ownership_type: 'VA Owned Asset',
        delivery_mechanism: nil,
        staffing_type: 'VA Staff Only',
        va_secretary_10n_approved_date: '-12324',
        planned_activation_date: '-12684',
        station_number_suffix_reservation_effective_date: '05/23/1995',
        operational_date: '-14321',
        date_of_first_workload: 'Pre-FY2000',
        points_of_service: 2,
        street_address: '1 Test Ave',
        street_address_city: 'Las Vegas',
        street_address_state: 'NV',
        street_address_zip_code: '11111',
        street_address_zip_code_extension: '1111',
        county_street_address: 'Test',
        mailing_address: '1 Test Ave',
        mailing_address_city: 'Las Vegas',
        mailing_address_state: 'NV',
        mailing_address_zip_code: '11111',
        mailing_address_zip_code_extension: '1111',
        county_mailing_address: 'Test',
        station_phone_number: '207-623-8411',
        station_main_fax_number: '207-623-8412',
        after_hours_phone_number: '207-623-7211',
        pharmacy_phone_number: '286-322-1342',
        enrollment_coordinator_phone_number: '207-623-9332',
        patient_advocate_phone_number: '207-623-1122',
        latitude: '44.03409934',
        longitude: '-70.70545322',
        congressional_district: 'CD116_ME_23001',
        market: '01-b',
        sub_market: '01-b-9',
        sector: '01-b-10-A',
        fips_code: '23022',
        rurality: 'U',
        monday: '24/7',
        tuesday: '24/7',
        wednesday: '24/7',
        thursday: '24/7',
        friday: '24/7',
        saturday: '24/7',
        sunday: '24/7',
        hours_note: 'This is a test',
        slug: 'a-first-facility-test-common-name'
    )

    va_facilities_name = "BCDEFGHIJKLMNOPQRSTU".split(//)
    va_facilities_name.each_with_index do | name, i |
      station_num = i + 400
      VaFacility.create!(
        visn: @visn,
        sta3n: station_num,
        station_number: station_num,
        official_station_name: "#{name} Test name",
        common_name: "#{name} Test Common Name",
        classification: 'VA Medical Center (VAMC)',
        classification_status: 'Firm',
        mobile: 'No',
        parent_station_number: 414,
        official_parent_station_name: 'Test station',
        fy17_parent_station_complexity_level: i > 0 ? '1c-High Complexity' : '1b-High Complexity',
      )
    end
  end

  describe 'index page' do
    it 'should be there' do
      visit '/facilities'
      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_current_path(va_facilities_path)
      expect(page).to have_content("Facility directory")
      expect(page).to have_content("Looking for a full list of VISNs?")
      expect(page).to have_content("Facilities")
      expect(page).to have_content("VISN")
      expect(page).to have_content("Type")
      expect(page).to have_content("A Test name")
      expect(page).to have_content('U Test name')
      expect(find_all('.usa-select').first.value).to eq ''
    end

    context 'index page complexity filter' do
      it 'should filter by complexity type' do
        visit '/facilities'
        select "1a-High Complexity", :from => "facility_type_select"
        section = find(:css, '#directory_table')
        expect(section).to have_content('1A')
        expect(section).to have_no_content('1B')
        expect(section).to have_no_content('1C')

        select "1b-High Complexity", :from => "facility_type_select"
        expect(section).to have_content('1B')
        expect(section).to have_no_content('1A')
        expect(section).to have_no_content('1C')

        select "1c-High Complexity", :from => "facility_type_select"
        expect(section).to have_content('1C')
        expect(section).to have_no_content('1A')
        expect(section).to have_no_content('1B')
      end
    end

    context 'Sorting' do
      it 'should sort the results in asc and desc order' do
        visit '/facilities'
        section = find(:css, '#directory_table') #the :css may be optional depending on your Capybara.default_selector setting
        expect(page).to have_content(@va_facility1.common_name)
        expect(page).to have_content("Load more")
        expect(section).to have_no_content("U Test name")
        expect(section).to have_content('first facility')
        toggle_by_column('facility')
        expect(section).to have_content("U Test name")
        expect(section).to have_no_content('first facility')
        find('#btn_facility_directory_load_more').click
        expect(section).to have_content("U Test name")
        expect(section).to have_content('first facility')
      end
    end
  end

  def toggle_by_column(column_name)
    find('#toggle_by_' + column_name).click
  end

  describe 'show page' do
    it 'should be there if the VA facility common name (friendly id) or id exists in the DB' do
      # visit using the friendly id
      visit '/facilities/a-first-facility-test-common-name'
      expect(page).to have_current_path(va_facility_path(@va_facility1))
    end

    context 'created practices search' do
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

        @practices.each_with_index do |pr, index|
          PracticeOriginFacility.create!(practice: pr, facility_id: '421', facility_type: 0)
          if pr.name == 'Different practice'
            CategoryPractice.create!(practice: pr, category: cat_3)
            CategoryPractice.create!(practice: pr, category: cat_4)
          elsif index < 3
            CategoryPractice.create!(practice: pr, category: cat_1)
          elsif index >= 3
            CategoryPractice.create!(practice: pr, category: cat_2)
            CategoryPractice.create!(practice: pr, category: cat_4)
            PracticeOriginFacility.create!(practice: pr, facility_id: '402', facility_type: 0)
          end
        end

        dh_1 = DiffusionHistory.create!(practice_id: @practices[4].id, facility_id: '401')
        DiffusionHistoryStatus.create!(diffusion_history_id: dh_1.id, status: 'Completed')
        dh_2 = DiffusionHistory.create!(practice_id: @practices[4].id, facility_id: '402')
        DiffusionHistoryStatus.create!(diffusion_history_id: dh_2.id, status: 'Completed')
        dh_3 = DiffusionHistory.create!(practice_id: @practices[3].id, facility_id: '401')
        DiffusionHistoryStatus.create!(diffusion_history_id: dh_3.id, status: 'Completed')
        dh_4 = DiffusionHistory.create!(practice_id: @practices[6].id, facility_id: '401')
        DiffusionHistoryStatus.create!(diffusion_history_id: dh_4.id, status: 'Completed')
        dh_5 = DiffusionHistory.create!(practice_id: @practices[0].id, facility_id: '402')
        DiffusionHistoryStatus.create!(diffusion_history_id: dh_5.id, status: 'Completed')
        dh_6 = DiffusionHistory.create!(practice_id: @practices[4].id, facility_id: '403')
        DiffusionHistoryStatus.create!(diffusion_history_id: dh_6.id, status: 'Completed')

        visit '/facilities/a-first-facility-test-common-name'
      end

      it 'should display the correct default content' do
        within(:css, '.dm-facility-created-practice-search') do
          # should see all the categories
          within(:css, '.dm-created-practice-categories') do
            expect(page).to have_content('COVID')
            expect(page).to have_content('Telehealth')
            expect(page).to have_no_content('Other')
            expect(page).to have_no_content('Other Subcategory')
            expect(page).to have_no_content('Main Level Cat')
          end
          expect(find(".dm-created-practice-categories.usa-select").value).to eq("")
          expect(find("#dm-created-practice-search-field").value).to eq("")
          expect(find(".dm-created-practice-results-count").text).to eq("8 results:")
          expect(find("#dm-created-practices-sort-option").value).to eq("a_to_z")
          # should see 3 sort filters
          within(:css, "#dm-created-practices-sort-option") do
            expect(page).to have_content('Sort by A to Z')
            expect(page).to have_content('Sort by most adopted practices')
            expect(page).to have_content('Sort by most recently added')
          end
          page.has_button?('Load more')
          expect(find_all('.dm-practice-title')[0]).to have_text('BIONE')
          expect(find_all('.dm-practice-title')[1]).to have_text('Cards for Memory')
          expect(find_all('.dm-practice-title').last).to have_text('Different practice')
          expect(page).to have_css('.dm-practice-card', count: 3)
          find('.dm-load-more-created-practices-btn').click
          page.has_button?('Load more')
          expect(page).to have_css('.dm-practice-card', count: 6)
          expect(find_all('.dm-practice-title')[3]).to have_text('GERIVETZ')
          expect(find_all('.dm-practice-title')[4]).to have_text('Gerofit')
          expect(find_all('.dm-practice-title')[5]).to have_text('Pink Gloves Program')
          find('.dm-load-more-created-practices-btn').click
          expect(page).to have_css('.dm-practice-card', count: 8)
          expect(find_all('.dm-practice-title')[6]).to have_text('REVAMP')
          expect(find_all('.dm-practice-title')[7]).to have_text('Telemedicine')
          page.has_no_button?('Load more')
        end
      end

      it 'should sort the content by most adopted practices' do
        within(:css, '.dm-facility-created-practice-search') do
          select 'Sort by most adopted practices', from: 'dm-created-practices-sort-option'
          expect(page).to have_content('8 results')
          page.has_button?('Load more')
          expect(find_all('.dm-practice-title')[0]).to have_text('Pink Gloves Program')
          expect(find_all('.dm-practice-title')[1]).to have_text('Gerofit')
          expect(find_all('.dm-practice-title').last).to have_text('Telemedicine')
          expect(page).to have_css('.dm-practice-card', count: 3)
          find('.dm-load-more-created-practices-btn').click
          expect(page).to have_css('.dm-practice-card', count: 6)
          expect(find_all('.dm-practice-title')[3]).to have_text('Cards for Memory')
          expect(find_all('.dm-practice-title')[4]).to have_text('BIONE')
          expect(find_all('.dm-practice-title')[5]).to have_text('Different practice')
          find('.dm-load-more-created-practices-btn').click
          expect(page).to have_css('.dm-practice-card', count: 8)
          expect(find_all('.dm-practice-title')[6]).to have_text('GERIVETZ')
          expect(find_all('.dm-practice-title').last).to have_text('REVAMP')
          page.has_no_button?('Load more')
        end
      end

      it 'should sort the content by most recently added' do
        within(:css, '.dm-facility-created-practice-search') do
          select 'Sort by most recently added', from: 'dm-created-practices-sort-option'
          expect(page).to have_content('8 results')
          page.has_button?('Load more')
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
          page.has_no_button?('Load more')
        end
      end

      it 'should filter by categories and allow for sorting' do
        within(:css, '.dm-facility-created-practice-search') do
          select 'COVID', from: 'dm-created-practice-categories'
          expect(page).to have_content('Cards for Memory')
          expect(page).to have_content('BIONE')
          expect(page).to have_content('GERIVETZ')
          expect(page).to have_content('3 results')
        end
      end

      it 'should allow search for practice info' do
        within(:css, '.dm-facility-created-practice-search') do
          fill_in 'dm-created-practice-search-field', :with => 'Cards'
          find('#dm-created-practice-search-button').click
          expect(page).to have_content('1 result')
          expect(page).to have_content('Cards for Memory')
          fill_in 'dm-created-practice-search-field', :with => 'tagline for BIONE'
          find('#dm-created-practice-search-button').click
          expect(page).to have_content('1 result')
          expect(page).to have_content('BIONE')
          fill_in 'dm-created-practice-search-field', :with => 'summary for Telemedicine'
          find('#dm-created-practice-search-button').click
          expect(page).to have_content('1 result')
          expect(page).to have_content('Telemedicine')
          fill_in 'dm-created-practice-search-field', :with => 'overview problem for GERIVETZ'
          find('#dm-created-practice-search-button').click
          expect(page).to have_content('1 result')
          expect(page).to have_content('GERIVETZ')
          fill_in 'dm-created-practice-search-field', :with => 'overview solution for Pink gloves ProGram'
          find('#dm-created-practice-search-button').click
          expect(page).to have_content('1 result')
          expect(page).to have_content('Pink Gloves Program')
          fill_in 'dm-created-practice-search-field', :with => 'Overview Results for REVAmp'
          find('#dm-created-practice-search-button').click
          expect(page).to have_content('1 result')
          expect(page).to have_content('REVAMP')
          fill_in 'dm-created-practice-search-field', :with => 'emerging'
          find('#dm-created-practice-search-button').click
          expect(page).to have_content('8 results')
          page.has_button?('Load more')
        end
      end

      it 'should allow search for practice origin facility and adopting facility' do
        within(:css, '.dm-facility-created-practice-search') do
          fill_in 'dm-created-practice-search-field', :with => 'd test name'
          find('#dm-created-practice-search-button').click
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
        within(:css, '.dm-facility-created-practice-search') do
          fill_in 'dm-created-practice-search-field', :with => 'coronavirus'
          find('#dm-created-practice-search-button').click
          expect(page).to have_content('3 results')
          expect(page).to have_content('Cards for Memory')
          expect(page).to have_content('BIONE')
          expect(page).to have_content('GERIVETZ')
          fill_in 'dm-created-practice-search-field', :with => 'telehealth'
          find('#dm-created-practice-search-button').click
          expect(page).to have_content('4 results')
          expect(page).to have_content('Gerofit')
          expect(page).to have_content('Pink Gloves Program')
          expect(page).to have_content('REVAMP')
          page.has_button?('Load more')
        end
      end
    end
  end
end
