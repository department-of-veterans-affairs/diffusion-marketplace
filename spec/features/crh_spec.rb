require 'rails_helper'
require 'spec_helper'

describe 'CRH pages', type: :feature do

  before do
    @visn_1 = Visn.create!(name: 'visn_1', number: 1)
    @crh = ClinicalResourceHub.create!(name: 'crh1', visn_id: @visn_1.id)
  end
  describe 'show page' do
    it 'should throw error if crh_path not defined' do
      visit clinical_resource_hub_path
      expect(page).to have_content('Page not found')
      expect(page).to have_content('We\'re sorry, we can\'t find the page you\'re looking for. It might have been removed, changed names, or is otherwise unavailable.')
    end

    if 'should throw error if visn_number not found in DB'
      visit clinical_resource_hub_path(@crh)
      expect(page).to_not have_content('Page not found')
      expect(page).to_not have_content('We\'re sorry, we can\'t find the page you\'re looking for. It might have been removed, changed names, or is otherwise unavailable.')
    end
  end
end