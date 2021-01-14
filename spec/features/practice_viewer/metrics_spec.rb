require 'rails_helper'

describe 'Metrics section', type: :feature, js: true do
  before do
    @admin = User.create!(email: 'toshiro.hitsugaya@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @user1 = User.create!(email: 'hisagi.shuhei@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @user1.add_role(User::USER_ROLES[0].to_sym)
    @user2 = User.create!(email: 'momo.hinamori@soulsociety.com', first_name: 'Momo', last_name: 'H', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @practice = Practice.create!(name: 'A public practice', approved: true, published: true, tagline: 'Test tagline', support_network_email: 'test@test.com')
    @practice_partner = PracticePartner.create!(name: 'Diffusion of Excellence', short_name: '', description: 'The Diffusion of Excellence Initiative', icon: 'fas fa-heart', color: '#E4A002')
    @practice_email = PracticeEmail.create!(practice: @practice, address: 'test2@test.com')
  end

  describe 'Authorization' do
    before do
      login_as(@admin, :scope => :user, :run_callbacks => false)
      visit practice_metrics_path(@practice)
      expect(page).to be_accessible.according_to :wcag2a, :section508
    end
    it 'Should allow authenticated users to view metrics' do
      # Login as an authenticated user and visit the practice page
      login_as(@user1, :scope => :user, :run_callbacks => false)
      visit practice_path(@practice)
      click_link('Edit')
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
  end
end