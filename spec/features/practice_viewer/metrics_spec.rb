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
      click_link('Edit practice')
      expect(page).to have_content(@practice.name)
    end
    it 'should allow user to toggle between 30 days and All time views' do
      login_as(@user1, :scope => :user, :run_callbacks => false)
      visit practice_metrics_path(@practice)

      select 'all time', from: 'metrics_duration'
      expect(page).to have_select('metrics_duration', selected: 'all time')
      expect(page).to have_content('Leaderboard')

      select 'the last 30 days', from: 'metrics_duration'
      expect(page).to have_select('metrics_duration', selected: 'the last 30 days')
    end

    it 'should display last time practice was updated.' do
      login_as(@user1, :scope => :user, :run_callbacks => false)
      PracticeEditorSession.create(user_id: @user1.id, practice_id: @practice.id, session_start_time: DateTime.now, session_end_time: DateTime.now, created_at: DateTime.now, updated_at: DateTime.now)
      visit practice_metrics_path(@practice)
      expect(page).to have_content('Practice last updated on')
      space = " "
      expect(page).to have_content("#{@user1.first_name}#{space}#{@user1.last_name}")
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
      click_link 'Edit practice'

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
