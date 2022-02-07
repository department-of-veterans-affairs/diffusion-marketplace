require 'rails_helper'

describe 'Metrics section', type: :feature, js: true do
  before do
    @admin = User.create!(email: 'toshiro.hitsugaya@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @user1 = User.create!(first_name: 'Fred', last_name: 'Smalls', email: 'hisagi.shuhei@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @user1.add_role(User::USER_ROLES[0].to_sym)
    @user2 = User.create!(email: 'momo.hinamori@va.gov', first_name: 'Momo', last_name: 'H', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @practice = Practice.create!(name: 'A public practice', approved: true, published: true, tagline: 'Test tagline', support_network_email: 'test@va.gov', user: @admin)
    @practice_partner = PracticePartner.create!(name: 'Diffusion of Excellence', short_name: '', description: 'The Diffusion of Excellence Initiative', icon: 'fas fa-heart', color: '#E4A002')
    @practice_email = PracticeEmail.create!(practice: @practice, address: 'test2@va.gov')
    visn_1 = Visn.create!(id: 1, name: "VA New England Healthcare System", number: 1)
    visn_2 = Visn.create!(id: 2, name: "New York/New Jersey VA Health Care Network", number: 2)
    facility_1 = VaFacility.create!(
      visn: visn_1,
      station_number: "402",
      official_station_name: "Togus VA Medical Center",
      common_name: "Togus",
      street_address_state: "ME",
      fy17_parent_station_complexity_level: "1a-High Complexity",
      rurality: "U",
      latitude: 44.2802701,
      longitude: -69.70413586
    )
    facility_1 = VaFacility.create!(
      visn: visn_1,
      station_number: "438GD",
      official_station_name: "Aberdeen VA Clinic",
      common_name: "Aberdeen",
      street_address_state: "SD",
      fy17_parent_station_complexity_level: "1a-High Complexity",
      rurality: "U",
      latitude: 44.2928701,
      longitude: -69.4933586
    )
    facility_2 = VaFacility.create!(
      visn: visn_2,
      station_number: "528QK",
      official_station_name: "Saranac Lake VA Clinic",
      common_name: "Saranac Lake",
      street_address_state: "NY",
      fy17_parent_station_complexity_level: "1b-High Complexity",
      rurality: "U",
      latitude: 44.33065263,
      longitude: -74.1327211,
    )
    dh_1 = DiffusionHistory.create!(practice_id: @practice.id, va_facility: facility_1)
    DiffusionHistoryStatus.create!(diffusion_history_id: dh_1.id, status: 'Completed')
    dh_2 = DiffusionHistory.create!(practice_id: @practice.id, va_facility: facility_2, created_at: Time.now - 35.days)
    DiffusionHistoryStatus.create!(diffusion_history_id: dh_2.id, status: 'Completed', created_at: Time.now - 35.days)
    login_as(@admin, :scope => :user, :run_callbacks => false)
    visit practice_metrics_path(@practice)
  end

  describe 'Authorization' do
    before do
      expect(page).to be_accessible.according_to :wcag2a, :section508
    end

    it 'Should allow authenticated users to view metrics' do
      # Login as an authenticated user and visit the practice page
      login_as(@user1, :scope => :user, :run_callbacks => false)
      visit practice_path(@practice)
      click_link('Edit innovation')
      expect(page).to have_content(@practice.name)
    end

    it 'should allow user to toggle between 30 days and All time views' do
      login_as(@user1, :scope => :user, :run_callbacks => false)
      visit practice_metrics_path(@practice)

      select 'all time', from: 'metrics_duration'
      expect(page).to have_select('metrics_duration', selected: 'all time')
      expect(page).to have_content('Leaderboard')

      # Check facility type adoption counts for all time
      find('#toggle_adoptions_view_all_time').click
      expect(page).to have_css('.rural-adoptions-count-at', text: '0')
      expect(page).to have_css('.urban-adoptions-count-at', text: '2')


      select 'the last 30 days', from: 'metrics_duration'
      expect(page).to have_select('metrics_duration', selected: 'the last 30 days')

      # Check facility type adoption counts from the last 30 days
      find('#toggle_adoptions_view_30').click
      expect(page).to have_css('.rural-adoptions-count-last-30', text: '0')
      expect(page).to have_css('.urban-adoptions-count-last-30', text: '1')
    end
  end

  describe 'Bookmark counts' do
    before do
      UserPractice.create(user: @user1, practice: @practice, favorited: true, time_favorited: DateTime.now - 60.days)
      UserPractice.create(user: @user2, practice: @practice, favorited: true, time_favorited: DateTime.now - 60.days)
    end

    it 'should display the correct number of bookmarks' do
      within(:css, '.dm-metrics-overall-stats') do
        bookmark_ct = find_all('td[style="font-size: 32px"]')[2].text
        expect(bookmark_ct).to eq("0")
      end
      select 'all time', from: 'metrics_duration'
      within(:css, '.dm-metrics-overall-stats') do
        bookmark_ct = find_all('td[style="font-size: 32px"]')[2].text
        expect(bookmark_ct).to eq("2")
      end

      visit practice_path(@practice)
      click_link 'Bookmark'
      click_link 'Edit innovation'

      within(:css, '.dm-metrics-overall-stats') do
        bookmark_ct = find_all('td[style="font-size: 32px"]')[2].text
        expect(bookmark_ct).to eq("1")
      end
      select 'all time', from: 'metrics_duration'
      within(:css, '.dm-metrics-overall-stats') do
        bookmark_ct = find_all('td[style="font-size: 32px"]')[2].text
        expect(bookmark_ct).to eq("3")
      end
    end
  end
end
