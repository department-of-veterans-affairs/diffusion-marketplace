require 'rails_helper'
require 'spec_helper'

describe 'CRH pages', type: :feature do
  describe 'show page' do
    it 'should throw error if crh_path not defined' do
      visit '/crh'
      expect(page).to have_content('Page not found')
      expect(page).to have_content('We\'re sorry, we can\'t find the page you\'re looking for. It might have been removed, changed names, or is otherwise unavailable.')
    end

    if 'should throw error if visn_number not found in DB'
      visit '/crh/150'
      expect(page).to have_content('Page not found')
      expect(page).to have_content('We\'re sorry, we can\'t find the page you\'re looking for. It might have been removed, changed names, or is otherwise unavailable.')
    end
  end
end