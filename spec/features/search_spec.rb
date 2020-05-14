require 'rails_helper'

describe 'Search', type: :feature do
  before do
    @user = User.create!(email: 'spongebob.squarepants@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @user2 = User.create!(email: 'patrick.star@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin = User.create!(email: 'sandy.cheeks@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @approver = User.create!(email: 'squidward.tentacles@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(User::USER_ROLES[1].to_sym)
    @approver.add_role(User::USER_ROLES[0].to_sym)
    @user_practice = Practice.create!(name: 'The Best Practice Ever!', user: @user, initiating_facility: 'Test facility name', tagline: 'Test tagline')
    @user_practice2 = Practice.create!(name: 'Another Best Practice', user: @user, initiating_facility: '687HA', tagline: 'Test tagline 2')
  end

  describe 'results' do
    it 'should show practices that are approved and published'do
      @user_practice.update(published: true, approved: true)
      login_as(@user, :scope => :user, :run_callbacks => false)
      visit '/search'
      expect(page).to be_accessible.according_to :wcag2a, :section508

      fill_in('practice-search-field', with: 'Test')
      click_button('Search')

      expect(page).to be_accessible.according_to :wcag2a, :section508

      # test facility data map for name, negative case
      expect(page).to have_content(@user_practice.name)
      expect(page).to have_content(@user_practice.initiating_facility)
      expect(page).to have_content('1 result for "Test"')

      # do not show a practice that is not approved/published
      fill_in('practice-search-field', with: 'practice')
      click_button('Search')

      expect(page).to have_content('1 result for "practice"')

      # show practices that are approved/published
      @user_practice2.update(published: true, approved: true)
      visit '/search'

      fill_in('practice-search-field', with: 'practice')
      click_button('Search')

      expect(page).to be_accessible.according_to :wcag2a, :section508

      expect(page).to have_content(@user_practice.name)
      expect(page).to have_content(@user_practice2.name)
      expect(page).to have_content('2 results for "practice"')

      # test facility data map for name, positive case
      expect(page).to have_content('Yakima VA Clinic')

    end

  end

  describe 'Cache' do
    it 'Should be cleared if certain practice attributes have been updated' do
      login_as(@admin, :scope => :user, :run_callbacks => false)
      visit '/search'
      fill_in('practice-search-field', with: 'Test')
      click_button('Search')
      parsed_uri = URI.parse(page.current_url)

      expect(Rails.cache.redis.keys).to include("views/#{parsed_uri.host}:#{parsed_uri.port}/search")
    end
  end

end