# frozen_string_literal: true
require 'rails_helper'

describe 'Practice Show Page Diffusion Map', type: :feature, js: true do
  before do
    Rake::Task['visns:create_visns_and_transfer_data'].execute
    Rake::Task['va_facilities:create_va_facilities_and_transfer_data'].execute

    @user = User.create!(email: 'spongebob.squarepants@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @practice = Practice.create!(name: 'The Best Practice Ever!', user: @user, initiating_facility: 'Test Facility', initiating_facility_type: 'other', tagline: 'Test tagline')
    ENV['GOOGLE_API_KEY'] = ENV['GOOGLE_TEST_API_KEY']
    @dh = DiffusionHistory.create!(practice: @practice, facility_id: '596')
    @dh_1 = DiffusionHistory.create!(practice: @practice, facility_id: '528')
    @dh_2 = DiffusionHistory.create!(practice: @practice, facility_id: '589A4')
    @dh_3 = DiffusionHistory.create!(practice: @practice, facility_id: '589A6')
    @dh_4 = DiffusionHistory.create!(practice: @practice, facility_id: '589A7')
    @dh_5 = DiffusionHistory.create!(practice: @practice, facility_id: '657')

    @dhs = DiffusionHistoryStatus.create!(diffusion_history: @dh, status: 'In progress')
    @dhs_1 = DiffusionHistoryStatus.create!(diffusion_history: @dh_1, status: 'Unsuccessful')
    @dhs_2 = DiffusionHistoryStatus.create!(diffusion_history: @dh_2, status: 'Unsuccessful')
    @dhs_3 = DiffusionHistoryStatus.create!(diffusion_history: @dh_3, status: 'Completed')
    @dhs_4 = DiffusionHistoryStatus.create!(diffusion_history: @dh_4, status: 'Completed')
    @dhs_5 = DiffusionHistoryStatus.create!(diffusion_history: @dh_5, status: 'Completed')

    login_as(@user, :scope => :user, :run_callbacks => false)
  end

  after do
    ENV['GOOGLE_API_KEY'] = nil
  end

  context 'when visiting a practice page with diffusion history' do
    it 'should show the map and allow for filtering' do
      # need to select by title since there are duplicate divs with the same width
      marker_div = 'div[style*="width: 31px"][title=""]'
      visit practice_path(@practice)
      expect(page).to have_selector('.dm-practice-diffusion-map', visible: true)
      expect(page).to have_selector(marker_div, visible: true)

      # filters button
      expect(page).to be_accessible.within '#mapFilters'
      # all markers
      marker_count = find_all(:css, marker_div).count
      expect(marker_count).to eq(6)

      # Filter out "Complete" status
      complete_filter_checkbox = find(:css, 'label[for="status_complete"]')
      complete_filter_checkbox.click
      expect(page).to have_selector(marker_div, visible: true)
      marker_count = find_all(:css, marker_div).count
      expect(marker_count).to eq(3)

      # Filter out "In progress" status
      in_progress_filter_checkbox = find(:css, 'label[for="status_in_progress"]')
      in_progress_filter_checkbox.click
      expect(page).to have_selector(marker_div, visible: true)
      marker_count = find_all(:css, marker_div).count
      expect(marker_count).to eq(2)

      # Filter out "Unsuccessful" status
      unsuccessful_filter_checkbox = find(:css, 'label[for="status_unsuccessful"]')
      unsuccessful_filter_checkbox.click
      marker_count = find_all(:css, marker_div).count
      expect(marker_count).to eq(0)

      # Bring back "Complete"
      complete_filter_checkbox.click
      expect(page).to have_selector(marker_div, visible: true)
      marker_count = find_all(:css, marker_div).count
      expect(marker_count).to eq(3)
    end
  end
end
