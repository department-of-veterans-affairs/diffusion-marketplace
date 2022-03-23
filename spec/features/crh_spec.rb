require 'rails_helper'

describe 'Clinical_Resource_Hubs', type: :feature do
  before do
    @visn_1 = Visn.create!(name: 'visn_1', number: 1)
    @visn_2 = Visn.create!(name: 'visn_2', number: 2)
    @visn_3 = Visn.create!(name: 'visn_3', number: 3)
    @crh = ClinicalResourceHub.create!(official_station_name: 'VISN 1 Clinical Resource Hub', visn_id: @visn_1.id)
    @crh2 = ClinicalResourceHub.create!(official_station_name: 'VISN 2 Clinical Resource Hub', visn_id: @visn_2.id)
    @crh3 = ClinicalResourceHub.create!(official_station_name: 'VISN 3 Clinical Resource Hub', visn_id: @visn_3.id)
    @user = User.create!(email: 'nobara.kugisaki@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: false, confirmed_at: Time.now, accepted_terms: true)

    @practice = Practice.create!(name: 'The Best Innovation Ever!', initiating_facility_type: 'facility', tagline: 'Test tagline', date_initiated: 'Sun, 05 Feb 1992 00:00:00 UTC +00:00', summary: 'This is the best innovation ever.', overview_problem: 'overview-problem', published: true, enabled: true, approved: true, user: @user)
    @practice_2 = Practice.create!(name: 'An Awesome Practice!', initiating_facility_type: 'visn', initiating_facility: '2', tagline: 'Test tagline 2', date_initiated: 'Sun, 24 Oct 2004 00:00:00 UTC +00:00', summary: 'This is an awesome practice.', published: true, enabled: true, approved: true, user: @user)
    @practice_3 = Practice.create!(name: 'A Very Cool Practice!', initiating_facility_type: 'facility', tagline: 'Super cool tagline', date_initiated: 'Mon, 09 Mar 1999 00:00:00 UTC +00:00', summary: 'This is a very cool practice.', overview_problem: 'overview-problem', published: true, enabled: true, approved: true, user: @user)


    @dh = DiffusionHistory.create!(practice_id: @practice.id, clinical_resource_hub: @crh)
    DiffusionHistoryStatus.create!(diffusion_history: @dh, status: 'Completed', start_time: Time.now)
    @dh_2 = DiffusionHistory.create!(practice_id: @practice_2.id, clinical_resource_hub: @crh2)
    DiffusionHistoryStatus.create!(diffusion_history: @dh_2, status: 'Completed', start_time: Time.now)
    @dh_3 = DiffusionHistory.create!(practice_id: @practice_3.id, clinical_resource_hub: @crh3)
    DiffusionHistoryStatus.create!(diffusion_history: @dh_3, status: 'Completed', start_time: Time.now)

    login_as(@user, :scope => :user, :run_callbacks => false)
  end

  describe 'CRH show page' do
    describe 'route works' do
      it 'should not show 404' do
        visit '/crh/1'
        expect(page).to_not have_content('Page not found')
        expect(page).to_not have_content('We\'re sorry, we can\'t find the page you\'re looking for. It might have been removed, changed names, or is otherwise unavailable.')
      end
    end
    describe 'crh show page works' do
      it 'should display content' do
        visit '/crh/1'
        expect(page).to have_content('Clinical Resource Hub (CRH) serves veterans in')
        visit '/crh/2'
        expect(page).to have_content('Clinical Resource Hub (CRH) serves veterans in')
      end
      it 'should display adopted practice cards' do
        visit '/crh/1'
        find_all('.usa-radio__label').last.click
        expect(practice_cards.count).to eq(1)
      end
      it 'should display CRH info modal and close' do
        visit '/crh/1'
        # find('#crh_info_modal').click
        find("a[href='#crh-info-modal']").click
        expect(page).to have_content("Clinical Resource Hubs (CRH) are a network of solutions that combines in-person care and telehealth to support underserved medical facilities.")
        # check to make sure it closes properly
        find('.usa-modal__close').click
        expect(page).to_not have_content("Clinical Resource Hubs (CRH) are a network of solutions that combines in-person care and telehealth to support underserved medical facilities.")
      end
      it 'should display breadcrumb to facilities index page' do
        visit '/crh/1'
        expect(page).to have_content("Facility index")
        find("a[href='/facilities']").click
        expect(page).to have_content("for a full list of VISNs?")
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

  def practice_cards
    find_all('.dm-practice-card', visible: true)
  end
end