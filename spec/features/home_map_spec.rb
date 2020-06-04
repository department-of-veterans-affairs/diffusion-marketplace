# frozen_string_literal: true

require 'rails_helper'
require 'rake'

describe 'HomeMap', type: :feature do
  before do
    Rake::Task['db:seed'].execute
    Rake::Task['importer:import_answers'].execute
    Rake::Task['diffusion_history:flow3'].execute
    ENV['GOOGLE_API_KEY'] = ENV['GOOGLE_TEST_API_KEY']
  end

  after do
    ENV['GOOGLE_API_KEY'] = nil
  end

  def open_filters
    find("#filterResultsTrigger").click
  end

  def update_results
    click_on('Update results')
  end

  context 'when visiting the homepage' do
    it 'the map shows up and filters are working' do
      visit '/'

      # filters button
      expect(page).to be_accessible.within '#filterResultsTrigger'

      # filters area
      open_filters
      expect(page).to be_accessible.within '#filterResults'

      # click a checkbox
      test_filter_checkbox = find(:css, 'label[for="1c_high_complexity"]')
      test_filter_checkbox.click

      # filter the markers
      update_results

      markers = page.all(:css, 'div[style*="width: 31px"]')
      expect(markers.count).to be(2)

    end

    it 'autocompletes facility names' do
      visit '/'
      open_filters

      find('#facility_name').set('Ja')
      expect(page).to have_content('Jamaica Plain VA Medical Center')
      expect(page).to have_content('Jamestown VA Clinic')
      expect(page).to have_content('James J. Howard Veterans\' Outpatient Clinic')
    end

    it 'should show unsuccessful adoptions' do
      visit '/'
      open_filters
      all('.usa-checkbox__label').first.click
      find('.adoption-status-label:nth-of-type(2)').click
      test_filter_checkbox = find(:css, 'label[for="1c_high_complexity"]')
      test_filter_checkbox.click

      update_results
      page.all(:css, 'img[style*="width: 31px"]').first.click
      debugger
      expect(page).to have_content('unsuccessful')
    end
  end
end