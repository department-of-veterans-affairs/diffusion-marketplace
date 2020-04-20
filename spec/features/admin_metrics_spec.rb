require 'rails_helper'


describe 'Admin Dashboard Metrics Tab', type: :feature do
  before do
    @admin = User.create!(email: 'sandy.cheeks@bikinibottom.net', password: 'Password123',
                          password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(:admin)
    @practice = Practice.create!(name: 'The Best Practice Ever!', user: @user, initiating_facility: 'Test facility name', tagline: 'Test tagline')
    @user_practice = UserPractice.create(time_favorited: DateTime.now - 1.months, user: @admin, practice: @practice, time_committed: DateTime.now - 1.months, committed: true)
    login_as(@admin, scope: :user, run_callbacks: false)
    visit '/admin'
  end

  fit 'should display at least one time_favorited' do
    debugger
    click_link 'Metrics'
    within(:css, '#favorited_stats') do
      td_element = find('td[class*="-_last_month"')
      expect(td_element.text).to eq('1')
    end
    within(:css, '#adopted_stats') do
      td_element = find('td[class*="-_last_month"')
      expect(td_element.text).to eq('1')
    end
    @user = User.create!(email: 'spongebob.squarepants@bikinibottom.net', password: 'Password123',
                         password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    UserPractice.create(time_favorited: DateTime.now - 1.months, user: @admin, practice: @practice, time_committed: DateTime.now - 1.months, committed: true)
    visit '/admin'
    click_link 'Metrics'
    within(:css, '#favorited_stats') do
      td_element = find('td[class*="-_last_month"')
      expect(td_element.text).to eq('2')
    end
    within(:css, '#adopted_stats') do
      td_element = find('td[class*="-_last_month"')
      expect(td_element.text).to eq('2')
    end
  end
end
