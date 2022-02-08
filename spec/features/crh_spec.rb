require 'rails_helper'

describe 'Clinical_Resource_Hubs', type: :feature do
  before do
    @visn_1 = Visn.create!(name: 'visn_1', number: 1)
    @crh = ClinicalResourceHub.create!(official_station_name: 'VISN 1 Clinical Resource Hub', visn_id: @visn_1.id)
  end

  describe 'CRH show page' do
    describe 'route works' do
      it 'should not show 404' do
        visit '/crh/1'
        expect(page).to_not have_content('Page not found')
        expect(page).to_not have_content('We\'re sorry, we can\'t find the page you\'re looking for. It might have been removed, changed names, or is otherwise unavailable.')
      end
    end
  end

  describe 'Cache' do
    it 'should reset if a CRH is created, updated, or destroyed' do
      # update a CRH
      @crh.update_attributes(official_station_name: 'Updated VISN 1 Clinical Resource Hub')
      expect(cache_keys).to_not include('clinical_resource_hubs')

      visit_search_page
      expect(cache_keys).to include('clinical_resource_hubs')


      # create a CRH
      ClinicalResourceHub.create!(official_station_name: 'VISN 2 Clinical Resource Hub', visn_id: @visn_1.id)
      expect(cache_keys).to_not include('clinical_resource_hubs')

      visit_search_page
      expect(cache_keys).to include('clinical_resource_hubs')

      # destroy a CRH
      @crh.destroy
      expect(cache_keys).to_not include('clinical_resource_hubs')

      visit_search_page
      expect(cache_keys).to include('clinical_resource_hubs')
    end
  end

  def cache_keys
    Rails.cache.redis.keys
  end

  def visit_search_page
    visit '/search'
  end
end