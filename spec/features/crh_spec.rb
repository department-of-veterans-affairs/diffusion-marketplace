require 'rails_helper'

describe 'Clinical_Resource_Hubs', type: :feature do
  before do
    @visn_1 = Visn.create!(name: 'visn_1', number: 1)
    @crh = ClinicalResourceHub.create!(name: 'crh1', visn_id: @visn_1.id)
  end

  describe 'CRH show page' do
    describe 'bad route' do
      it 'should show 404 error' do
        visit '/crh/'
        expect(page).to have_content('Page not found')
        expect(page).to have_content('We\'re sorry, we can\'t find the page you\'re looking for. It might have been removed, changed names, or is otherwise unavailable.')
      end
    end

    describe 'route works' do
      it 'should not show 404' do
        visit '/crh/1'
        expect(page).to_not have_content('Page not found')
        expect(page).to_not have_content('We\'re sorry, we can\'t find the page you\'re looking for. It might have been removed, changed names, or is otherwise unavailable.')
      end
    end
  end
end