require 'rails_helper'

describe 'Explore all practices page', type: :feature do
  before do
    cat_1 = Category.create!(name: 'COVID')
    cat_2 = Category.create(name: 'Telehealth')
    cat_3 = Category.create!(name: 'Other')
    cat_4 = Category.create!(name: 'Other Subcategory', is_other: true)
    cat_5 = Category.create!(name: 'Main Level Cat')

    practice_names = ['Cards for Memory', 'BIONE', 'GLOW3', 'Beach VA', 'Virtual Care', 'COPD', 'GERIVETZ', 'Gerofit', 'Pink Gloves Program', 'SOAR', 'Project Happenings', 'REVAMP', 'Telemedicine', 'Different practice']
    @practices = []
    practice_names.each do |name|
      @practices.push(Practice.create!(name: name, approved: true, published: true, tagline: "Tagline for #{name}", support_network_email: 'test@test.com'))
    end

    pr_1 = Practice.create!(name: 'Unpublished practice', approved: false, published: false)
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

    dh_1 = DiffusionHistory.create!(practice_id: @practices[0].id, facility_id: '516')
    DiffusionHistoryStatus.create!(diffusion_history_id: dh_1.id, status: 'Completed')
    dh_2 = DiffusionHistory.create!(practice_id: @practices[0].id, facility_id: '600GC')
    DiffusionHistoryStatus.create!(diffusion_history_id: dh_2.id, status: 'Completed')
    dh_3 = DiffusionHistory.create!(practice_id: @practices[3].id, facility_id: '516')
    DiffusionHistoryStatus.create!(diffusion_history_id: dh_3.id, status: 'Completed')
    dh_4 = DiffusionHistory.create!(practice_id: @practices[4].id, facility_id: '516')
    DiffusionHistoryStatus.create!(diffusion_history_id: dh_4.id, status: 'Completed')
  end

  describe 'Page content' do
    it 'should display the correct default content' do
      visit '/explore'
      expect(page).to have_content('COVID')
      expect(page).to have_content('Telehealth')
      expect(page).to have_no_content('Main Level Cat')
      expect(page).to have_content('14 results')
      page.has_button?('Load more')
      expect(page).to have_no_content('Other')
      expect(page).to have_no_content('Other Subcategory')
      expect(page).to have_no_css('.dm-selected')
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
      select 'Sort by most adoptions', from: 'dm_sort_option'
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
      expect(page).to have_no_css('.dm-selected')
      find_all('.dm-category-btn')[0].click
      expect(page).to have_css('.dm-selected', count: 1)
      expect(page).to have_no_content('Different practice')
      expect(page).to have_content('6 results')
      expect(page).to have_css('.dm-practice-card', count: 6)
      page.has_no_button?('Load more')
      expect(find_all('.dm-practice-title')[0]).to have_text('Beach VA')
      expect(find_all('.dm-practice-title')[1]).to have_text('BIONE')
      expect(find_all('.dm-practice-title')[5]).to have_text('Virtual Care')
      # sort by most adoptions
      select 'Sort by most adoptions', from: 'dm_sort_option'
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
      find_all('.dm-category-btn')[1].click
      expect(page).to have_content('13 results')
      expect(page).to have_css('.dm-selected', count: 2)
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
      # sort by most adoptions
      select 'Sort by most adoptions', from: 'dm_sort_option'
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
      expect(page).to have_no_css('.dm-selected')
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
      PracticeOriginFacility.create!(practice: pr, facility_type: 0, facility_id: '687HA')

      Rails.cache.clear
      expect(cache_keys).not_to include("searchable_practices_a_to_z")
      expect(cache_keys).not_to include("searchable_practices_added")
      expect(cache_keys).not_to include("searchable_practices_adoptions")

      visit explore_path
      expect(cache_keys).to include("searchable_practices_a_to_z")
      expect(cache_keys).not_to include("searchable_practices_added")
      expect(cache_keys).not_to include("searchable_practices_adoptions")

      select 'Sort by most adoptions', from: 'dm_sort_option'
      sleep 1
      expect(cache_keys).to include("searchable_practices_adoptions")

      select 'Sort by most recently added', from: 'dm_sort_option'
      sleep 1
      expect(cache_keys).to include("searchable_practices_added")

      login_as(admin, :scope => :user, :run_callbacks => false)
      # cache clears when adding a practice category
      visit practice_introduction_path(pr)
      find('#category_covid_label').click # selects Telehealth
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
      find('label[for="status_unsuccessful"').click
      select('Alaska', :from => 'editor_state_select')
      select('Anchorage VA Medical Center', :from => 'editor_facility_select')
      find('#adoption_form_submit').click
      sleep 1
      expect(cache_keys).not_to include("searchable_practices_a_to_z")
      visit explore_path
      expect(cache_keys).to include("searchable_practices_a_to_z")

      # cache clears when removing an adoption
      visit practice_adoptions_path(pr)
      find("button[aria-controls='unsuccessful_adoptions'").click
      find("button[aria-controls='diffusion_history_#{pr.diffusion_histories.first.id}']").click
      within(:css, "#diffusion_history_#{pr.diffusion_histories.first.id}") do
        click_link('Delete entry')
      end
      page.accept_alert
      sleep 1
      expect(cache_keys).not_to include("searchable_practices_a_to_z")
    end
  end
end
