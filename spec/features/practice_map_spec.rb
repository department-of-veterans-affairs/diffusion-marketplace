# frozen_string_literal: true

require 'rails_helper'
require 'rake'

describe 'HomeMap', type: :feature do
  before do
    Rake::Task['db:seed'].execute
    Rake::Task['importer:import_answers'].execute
    Rake::Task['diffusion_history:flow3'].execute
    ENV['GOOGLE_API_KEY'] = ENV['GOOGLE_TEST_API_KEY']
    DiffusionHistory.last.diffusion_history_statuses.find_by(end_time: nil).update_attributes(status: 'Unsuccessful')
    @user = User.create!(email: 'spongebob.squarepants@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    login_as(@user, :scope => :user, :run_callbacks => false)
  end

  after do
    ENV['GOOGLE_API_KEY'] = nil
  end

  context 'when visiting a practice page with diffusion history' do
    it 'the map shows up and filters are working' do
      # need to select by title since there are duplicate divs with the same width
      marker_div = 'div[style*="width: 31px"][title=""]'

      visit practice_path(Practice.first)

      # filters button
      expect(page).to be_accessible.within '#mapFilters'
      # all markers
      marker_count = find_all(:css, marker_div).count
      expect(marker_count).to eq(25)

      # Filter out "Complete" status
      complete_filter_checkbox = find(:css, 'label[for="status_complete"]')
      complete_filter_checkbox.click

      marker_count = find_all(:css, marker_div).count
      # 7 in progress and 1 unsuccessful
      expect(marker_count).to eq(8)

      # Filter out "In progress" status
      in_progress_filter_checkbox = find(:css, 'label[for="status_in_progress"]')
      in_progress_filter_checkbox.click

      # 1 unsuccessful
      marker_count = find_all(:css, marker_div).count
      expect(marker_count).to eq(1)

      # Filter out "Unsuccessful" status
      unsuccessful_filter_checkbox = find(:css, 'label[for="status_unsuccessful"]')
      unsuccessful_filter_checkbox.click

      # no markers
      marker_count = find_all(:css, marker_div).count
      expect(marker_count).to eq(0)

      # Bring back "Complete"
      complete_filter_checkbox.click
      marker_count = find_all(:css, marker_div).count
      # 17 complete
      expect(marker_count).to eq(17)
    end
  end
end
