# frozen_string_literal: true

require 'rails_helper'
require 'rake'
Rails.application.load_tasks

describe 'HomeMap', type: :feature do
  before do
    Rake::Task['db:seed'].execute
    Rake::Task['importer:import_answers'].execute
    Rake::Task['diffusion_history:flow3'].execute
    ENV['GOOGLE_API_KEY'] = ENV['GOOGLE_TEST_API_KEY']
  end

  after do
    Practice.find_by(slug: 'flow3').destroy
  end

  context 'when visiting the homepage' do
    it 'the map shows up and filters are working' do
      visit '/'

      # filters button
      expect(page).to be_accessible.within '#filterResultsTrigger'

      # filters area
      filters_trigger = find(:css, "#filterResultsTrigger")
      filters_trigger.click
      expect(page).to be_accessible.within '#filterResults'

      # click a checkbox
      test_filter_checkbox = find(:css, 'label[for="1c_high_complexity"]')
      test_filter_checkbox.click

      # filter the markers
      click_on('Update results')

      markers = page.all(:css, 'div[style*="width: 31px"]')
      expect(markers.count).to be(2)

    end
  end
end