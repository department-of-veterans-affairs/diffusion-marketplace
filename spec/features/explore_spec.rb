require 'rails_helper'

describe 'Explore all practices page', type: :feature do
  before do
    cat_1 = Category.create!(name: 'COVID')
    cat_2 = Category.create(name: 'Telehealth')
    cat_3 = Category.create!(name: 'Other')
    cat_4 = Category.create!(name: 'Other Subcategory', is_other: true)
    cat_5 = Category.create!(name: 'Main Level Cat')

    user = User.create!(email: 'test@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    practice_names = ['Cards for Memory', 'BIONE', 'GLOW3', 'Beach VA', 'Virtual Care', 'COPD', 'GERIVETZ', 'Gerofit', 'Pink Gloves Program', 'SOAR', 'Project Happenings', 'REVAMP', 'Telemedicine', 'Different practice']
    @practices = []
    practice_names.each do |name|
      @practices.push(Practice.create!(name: name, approved: true, published: true, tagline: "Tagline for #{name}", support_network_email: 'test@test.com', user: user))
    end
    pr_1 = Practice.create!(name: 'Unpublished practice', approved: false, published: false, user: user)
    CategoryPractice.create!(practice: pr_1, category: cat_5)

    @practices.each_with_index do |pr, index|
      if pr.name == 'Different practice'
        CategoryPractice.create!(practice: pr, category: cat_3)
        CategoryPractice.create!(practice: pr, category: cat_4)
      elsif index < 6
        CategoryPractice.create!(practice: pr, category: cat_1)
      elsif index >= 6
        CategoryPractice.create!(practice: pr, category: cat_2)
      end
    end

    visn_1 = Visn.create!(name: 'VISN 1', number: 2)
    visn_20 = Visn.create!(id: 15, name: "Northwest Network", number: 20)

    @fac_1 = VaFacility.create!(
      visn: visn_1,
      station_number: "402GA",
      official_station_name: "Caribou VA Clinic",
      common_name: "Caribou",
      street_address_state: "ME"
    )
    @fac_2 = VaFacility.create!(
      visn: visn_1,
      station_number: "526GA",
      official_station_name: "White Plains VA Clinic",
      common_name: "White Plains",
      street_address_state: "NY"
    )
    @fac_3 = VaFacility.create!(
      visn: visn_20,
      station_number: "687HA",
      official_station_name: "Yakima VA Clinic",
      common_name: "Yakima",
      street_address_state: "WA"
    )

    dh_1 = DiffusionHistory.create!(practice: @practices[0], va_facility: @fac_1)
    DiffusionHistoryStatus.create!(diffusion_history: dh_1, status: 'Completed')
    dh_2 = DiffusionHistory.create!(practice: @practices[0], va_facility: @fac_2)
    DiffusionHistoryStatus.create!(diffusion_history: dh_2, status: 'Completed')
    dh_3 = DiffusionHistory.create!(practice: @practices[3], va_facility: @fac_1)
    DiffusionHistoryStatus.create!(diffusion_history: dh_3, status: 'Completed')
    dh_4 = DiffusionHistory.create!(practice: @practices[4], va_facility: @fac_1)
    DiffusionHistoryStatus.create!(diffusion_history: dh_4, status: 'Completed')
  end

  describe 'Page content' do
    it 'should display the correct default content' do
      visit '/explore'
      expect(page).to have_content('COVID')
      expect(page).to have_content('TELEHEALTH')
      expect(page).to have_no_content('Main Level Cat')
      expect(page).to have_content('14 results')
      page.has_button?('Load more')
      expect(page).to have_no_content('Other')
      expect(page).to have_no_content('Other Subcategory')
      expect(page).to have_no_css('.dm-tag--big--action-primary--selected')
      expect(page).to have_select('dm_sort_option', selected: 'Sort by A to Z')
      expect(page).to have_content('14 results')
      expect(find_all('.dm-practice-title')[0]).to have_text('Beach VA')
      expect(find_all('.dm-practice-title')[1]).to have_text('BIONE')
      expect(find_all('.dm-practice-title').last).to have_text('SOAR')
      expect(page).to have_css('.dm-practice-card', count: 12)
      find('.dm-load-more-btn').click
      expect(page).to have_content('Virtual Care')
      expect(find_all('.dm-practice-title').last).to have_text('Virtual Care')
      expect(page).to have_css('.dm-practice-card', count: 14)
      expect(page).to have_no_content('Unpublished practice')
      page.has_no_button?('Load more')
    end

    it 'should sort the content by most adoptions' do
      visit '/explore'
      select 'Sort by most adopted practices', from: 'dm_sort_option'
      expect(page).to have_content('14 results')
      page.has_button?('Load more')
      expect(find_all('.dm-practice-title')[0]).to have_text('Cards for Memory')
      expect(find_all('.dm-practice-title')[1]).to have_text('Beach VA')
      expect(find_all('.dm-practice-title').last).to have_text('REVAMP')
      expect(page).to have_css('.dm-practice-card', count: 12)
      find('.dm-load-more-btn').click
      expect(page).to have_css('.dm-practice-card', count: 14)
      expect(find_all('.dm-practice-title').last).to have_text('Telemedicine')
      page.has_no_button?('Load more')
    end

    it 'should sort the content by most recently created' do
      visit '/explore'
      select 'Sort by most recently added', from: 'dm_sort_option'
      expect(page).to have_content('14 results')
      page.has_button?('Load more')
      expect(page).to have_content('GLOW3')
      expect(find_all('.dm-practice-title')[0]).to have_text('Different practice')
      expect(find_all('.dm-practice-title')[1]).to have_text('Telemedicine')
      expect(find_all('.dm-practice-title').last).to have_text('GLOW3')
      expect(page).to have_css('.dm-practice-card', count: 12)
      find('.dm-load-more-btn').click
      expect(page).to have_css('.dm-practice-card', count: 14)
      expect(find_all('.dm-practice-title').last).to have_text('Cards for Memory')
      page.has_no_button?('Load more')
    end

    it 'should filter by categories and allow for sorting' do
      visit '/explore'
      # filter by COVID category practices
      expect(page).to have_no_css('.dm-tag--big--action-primary--selected')
      find_all('.js-category-tag')[0].click
      expect(page).to have_css('.dm-tag--big--action-primary--selected', count: 1)
      expect(page).to have_no_content('Different practice')
      expect(page).to have_content('6 results')
      expect(page).to have_css('.dm-practice-card', count: 6)
      page.has_no_button?('Load more')
      expect(find_all('.dm-practice-title')[0]).to have_text('Beach VA')
      expect(find_all('.dm-practice-title')[1]).to have_text('BIONE')
      expect(find_all('.dm-practice-title')[5]).to have_text('Virtual Care')
      # Sort by most adopted practices
      select 'Sort by most adopted practices', from: 'dm_sort_option'
      expect(page).to have_content('6 results')
      expect(find_all('.dm-practice-title')[0]).to have_text('Cards for Memory')
      expect(find_all('.dm-practice-title')[1]).to have_text('Beach VA')
      expect(find_all('.dm-practice-title')[5]).to have_text('GLOW3')
      # sort by most recently added
      select 'Sort by most recently added', from: 'dm_sort_option'
      expect(page).to have_content('6 results')
      expect(find_all('.dm-practice-title')[0]).to have_text('COPD')
      expect(find_all('.dm-practice-title')[1]).to have_text('Virtual Care')
      expect(find_all('.dm-practice-title')[5]).to have_text('Cards for Memory')

      # filter by COVID and Telehealth category practices
      find_all('.js-category-tag')[1].click
      expect(page).to have_content('13 results')
      expect(page).to have_css('.dm-tag--big--action-primary--selected', count: 2)
      expect(page).to have_css('.dm-practice-card', count: 12)
      page.has_button?('Load more')
      expect(find_all('.dm-practice-title')[0]).to have_text('Telemedicine')
      expect(find_all('.dm-practice-title')[1]).to have_text('REVAMP')
      expect(find_all('.dm-practice-title')[11]).to have_text('BIONE')
      # sort by A to Z
      select 'Sort by A to Z', from: 'dm_sort_option'
      expect(page).to have_content('13 results')
      page.has_button?('Load more')
      expect(find_all('.dm-practice-title')[0]).to have_text('Beach VA')
      expect(find_all('.dm-practice-title')[1]).to have_text('BIONE')
      expect(find_all('.dm-practice-title')[11]).to have_text('Telemedicine')
      # Sort by most adopted practices
      select 'Sort by most adopted practices', from: 'dm_sort_option'
      expect(page).to have_content('13 results')
      page.has_button?('Load more')
      expect(find_all('.dm-practice-title')[0]).to have_text('Cards for Memory')
      expect(find_all('.dm-practice-title')[1]).to have_text('Beach VA')
      expect(find_all('.dm-practice-title')[11]).to have_text('SOAR')
      find('.dm-load-more-btn').click
      expect(page).to have_content('Telemedicine')
      expect(page).to have_no_content('Different practice')
      expect(find_all('.dm-practice-title')[12]).to have_text('Telemedicine')
      # refresh the page
      visit current_path
      # make sure the defaults are all set again
      expect(page).to have_no_css('.dm-tag--big--action-primary--selected')
      expect(page).to have_content('14 results')
      expect(page).to have_css('.dm-practice-card', count: 12)
      expect(page).to have_select('dm_sort_option', selected: 'Sort by A to Z')
    end
  end

  describe 'cache' do
    def cache_keys
      Rails.cache.redis.keys
    end

    it 'should cache the practices and clear them on changes to the practice' do
      admin = User.create!(email: 'sandy.cheeks@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
      admin.add_role(User::USER_ROLES[1].to_sym)

      pr = @practices[7]
      pr.update(summary: 'test summary', date_initiated: Time.now())
      PracticeOriginFacility.create!(practice: pr, facility_type: 0, va_facility: @fac_3)

      Rails.cache.clear
      expect(cache_keys).not_to include("searchable_practices_a_to_z")
      expect(cache_keys).not_to include("searchable_practices_added")
      expect(cache_keys).not_to include("searchable_practices_adoptions")

      visit explore_path
      expect(cache_keys).to include("searchable_practices_a_to_z")
      expect(cache_keys).not_to include("searchable_practices_added")
      expect(cache_keys).not_to include("searchable_practices_adoptions")

      select 'Sort by most adopted practices', from: 'dm_sort_option'
      sleep 1
      expect(cache_keys).to include("searchable_practices_adoptions")

      select 'Sort by most recently added', from: 'dm_sort_option'
      sleep 1
      expect(cache_keys).to include("searchable_practices_added")

      login_as(admin, :scope => :user, :run_callbacks => false)
      # cache clears when adding a practice category
      visit practice_introduction_path(pr)
      find('#practice-editor-save-button').click
      sleep 1
      expect(cache_keys).not_to include("searchable_practices_a_to_z")
      expect(cache_keys).not_to include("searchable_practices_added")
      expect(cache_keys).not_to include("searchable_practices_adoptions")
      visit explore_path
      expect(cache_keys).to include("searchable_practices_a_to_z")

      # cache clears when adding an adoption
      visit practice_adoptions_path(pr)
      find('#add_adoption_button').click
      find('label[for="status_in_progress"').click
      find('#editor_facility_select').click
      find('#editor_facility_select--list--option-0').click
      find('#adoption_form_submit').click
      sleep 1
      expect(cache_keys).not_to include("searchable_practices_a_to_z")
      visit explore_path
      expect(cache_keys).to include("searchable_practices_a_to_z")

      # cache clears when removing an adoption
      visit practice_adoptions_path(pr)
      find("button[aria-controls='in-progress_adoptions'").click
      find("button[aria-controls='diffusion_history_#{pr.diffusion_histories.first.id}']").click
      within(:css, "#diffusion_history_#{pr.diffusion_histories.first.id}") do
        click_link('Delete')
      end
      page.accept_alert
      sleep 1
      expect(cache_keys).not_to include("searchable_practices_a_to_z")
    end
  end
end
