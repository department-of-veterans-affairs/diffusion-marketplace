require 'rails_helper'
require 'spec_helper'

describe 'CRH pages', type: :feature do

  before do
    def visit_crh_page s_url
      visit s_url
    end
  end
  describe 'show page' do
    it 'should throw error if crh_path not defined' do
      visit_crh_page '/crh'
      expect(page).to have_content('Page not found')
      expect(page).to have_content('We\'re sorry, we can\'t find the page you\'re looking for. It might have been removed, changed names, or is otherwise unavailable.')
    end

    if 'should throw error if visn_number not found in DB'
      visit_crh_page '/crh/150'
      expect(page).to have_content('Page not found')
      expect(page).to have_content('We\'re sorry, we can\'t find the page you\'re looking for. It might have been removed, changed names, or is otherwise unavailable.')
    end
  end
end